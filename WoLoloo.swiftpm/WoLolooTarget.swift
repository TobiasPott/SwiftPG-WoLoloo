import SwiftUI

struct WoLolooTarget: Identifiable, Codable {
    public var id: UUID = UUID()
    
    var name: String = "YourDevice #1"
    var multicastAddr: String = "" //"192.168.178.*"
    var mac: String = "" // "58:47:ca:7b:aa:5a"
    var port: UInt16 = 9
    var createdAt: Date = .now
    
    var device: Awake.Device { get {
        return Awake.Device(MAC: mac, BroadcastAddr: multicastAddr.replacingOccurrences(of: "*", with: "255"), Port: port)
    }}
    var isValid: Bool { 
        get {  
            do {
                let macRegEx = try Regex("^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")
                if mac.ranges(of: macRegEx).count == 0 { return false }
                if mac.isEmpty || multicastAddr.isEmpty { return false }
            } catch {
                print("Failed to create regex")
                return false
            }
            return true
        }
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

struct WoLoloTargetControl: View {
    @Binding var target: WoLolooTarget
    let isBookmarked: Bool
    
    var body: some View {
        
        Grid {
            GridRow(alignment: .center, content: {
                GridLabel(title: "Name")
                TextField("Descriptive Name", text: $target.name)
                Image(systemName: isBookmarked ? "bookmark" : "bookmark.fill")
            })
            GridRow(alignment: .center, content: {
                GridLabel(title: "Broadcast")
                TextField("Broadcast IP/Host Name", text: $target.multicastAddr)
            })
            GridRow(alignment: .center, content: {
                GridLabel(title: "MAC")
                TextField("Wake-On-Lan MAC Address", text: $target.mac)
                    .onChange(of: target.mac, {
                        target.mac = target.mac.replacingOccurrences(of: "-", with: ":")
                    })
                
            })
            GridRow(alignment: .center, content: {
                GridLabel(title: "Port")
                TextField("Port (default = 9)", value: $target.port, formatter: NumberFormatter())
            })
            
            GridRow(alignment: .firstTextBaseline, content: {
                GridLabel(title: "Created")
                Text(target.createdAt.formatted(date: .abbreviated, time: .standard))
                    .allowsTightening(true)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            })
        }
    }    
}
