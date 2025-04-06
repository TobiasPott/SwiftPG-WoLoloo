import SwiftUI

struct WoLolooTarget: Identifiable, Codable, Equatable {
    static func ==(lhs: WoLolooTarget, rhs: WoLolooTarget) -> Bool {
        return (lhs.name == rhs.name && lhs.addr == rhs.addr
                && lhs.mac == rhs.mac) // || lhs.id == rhs.id
    }
    
    public var id: UUID = UUID()
    var name: String = "YourDevice #1"
    var addr: String = "" //"192.168.178.*"
    var mac: String = "" // "58:47:ca:7b:aa:5a"
    var port: UInt16 = 9
    var createdAt: Date = .now
    
    var device: Awake.Device { get {
        let devMac = mac.replacingOccurrences(of: "-", with: ":")
        let devAddr = addr.replacingOccurrences(of: "*", with: "255")
        return Awake.Device(MAC: devMac, BroadcastAddr: devAddr, 
                            Port: port)
    }}
    
    init(name: String = "Device Target #1", addr: String = "", mac: String = "", port: UInt16 = 9) {
        self.name = name
        self.addr = addr
        self.mac = mac
        self.port = port
    }
    
    func duplicate() -> Self {
        return .init(name: "\(self.name) (copy)", addr: self.addr, mac: self.mac, port: self.port)    
    }
    func wakeup() -> Request {
        let err = Awake.target(device: self.device)
        return .init(target: self, error: err)
    }
    struct Request: Identifiable {
        let id: UUID = UUID()
        let target: WoLolooTarget
        let error: Error?
        let sentAt: Date = .now
    }
    
}


