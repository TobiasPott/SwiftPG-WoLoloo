import SwiftUI

struct WoLolooTarget: Identifiable, Codable, Equatable {
    static func ==(lhs: WoLolooTarget, rhs: WoLolooTarget) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.addr == rhs.addr && lhs.mac == rhs.mac && lhs.port == rhs.port
    }
    
    public var id: UUID = UUID()
    var name: String = "Device #1"
    var addr: String = "192.168.178.*"
    var mac: String = "58:47:ca:7b:aa:5a"
    var port: UInt16 = 9
    var createdAt: Date = .now
    
    var device: Awake.Device { get {
        let devMac = mac.replacingOccurrences(of: "-", with: ":")
        let devAddr = addr.replacingOccurrences(of: "*", with: "255")
        return Awake.Device(MAC: devMac, BroadcastAddr: devAddr, 
                            Port: port)
    }}
    var userInfo: [String: NSSecureCoding] { get {
        return ["id": "\(self.id)" as NSSecureCoding,
                "name" : "\(self.name)" as NSSecureCoding,
                "addr": "\(self.addr)" as NSSecureCoding, 
                "mac": "\(self.mac)" as NSSecureCoding, 
                "port": "\(self.port)" as NSSecureCoding]
    } }
    
    
    init(name: String = "Unsaved #1", addr: String = "", mac: String = "", port: UInt16 = 9) {
        self.init(id: UUID(), name: name, addr: addr, mac: mac, port: port)
    }
    internal init(id: UUID, name: String = "Unsaved #1", addr: String = "", mac: String = "", port: UInt16 = 9) {
        self.id = id
        self.name = name
        self.addr = addr
        self.mac = mac.replacingOccurrences(of: "-", with: ":")
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


