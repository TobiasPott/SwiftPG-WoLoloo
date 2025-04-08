import Foundation
/*
 MIT License
 
 Copyright (c) 2017 Jesper Lindberg
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/
public class Awake {
    public struct Device {
        public init(MAC: String, BroadcastAddr: String, Port: UInt16 = 9) {
            self.MAC = MAC
            self.BroadcastAddr = BroadcastAddr
            self.Port = Port
        }
        
        var MAC: String
        var BroadcastAddr: String
        var Port: UInt16 = 9
    }
    
    public enum WakeError: Error {
        case SocketSetupFailed(reason: String)
        case SetSocketOptionsFailed(reason: String)
        case SendMagicPacketFailed(reason: String)
    }
    
    public static func target(device: Device) -> Error? {
        var sock: Int32
        var target = sockaddr_in()
        
//        print("Awake.target(\(device))")
        target.sin_family = sa_family_t(AF_INET)
        
        // Check Broadcast address (is an IP address or a domain name)
        var bcaddr = inet_addr(device.BroadcastAddr)
        if bcaddr == INADDR_NONE {
            bcaddr = inet_addr(gethostbyname(device.BroadcastAddr))
        }
        target.sin_addr.s_addr = bcaddr
        
        let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian
        target.sin_port = isLittleEndian ? _OSSwapInt16(device.Port) : device.Port
        
        // Setup the packet socket
        sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if sock < 0 {
            let err = String(utf8String: strerror(errno)) ?? ""
            return WakeError.SocketSetupFailed(reason: err)
        }
        
        let packet = Awake.createMagicPacket(mac: device.MAC)
        let sockaddrLen = socklen_t(MemoryLayout<sockaddr>.stride)
        let intLen = socklen_t(MemoryLayout<Int>.stride)
        
        // Set socket options
        var broadcast = 1
        if setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &broadcast, intLen) == -1 {
            close(sock)
            let err = String(utf8String: strerror(errno)) ?? ""
            return WakeError.SetSocketOptionsFailed(reason: err)
        }
        
        // Send magic packet
        var targetCast = unsafeBitCast(target, to: sockaddr.self)
        if sendto(sock, packet, packet.count, 0, &targetCast, sockaddrLen) != packet.count {
            close(sock)
            let err = String(utf8String: strerror(errno)) ?? ""
            return WakeError.SendMagicPacketFailed(reason: err)
        }
        
        close(sock)
        
        return nil
    }
    
    private static func createMagicPacket(mac: String) -> [CUnsignedChar] {
        var buffer = [CUnsignedChar]()
        
        // Create header
        for _ in 1...6 {
            buffer.append(0xFF)
        }
        
        let components = mac.components(separatedBy: ":")
        let numbers = components.map {
            return strtoul($0, nil, 16)
        }
        
        // Repeat MAC address 20 times
        for _ in 1...20 {
            for number in numbers {
                buffer.append(CUnsignedChar(number))
            }
        }
        
        return buffer
    }
}
