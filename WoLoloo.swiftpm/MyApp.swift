import SwiftUI

@main
struct MyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var target: WoLolooTarget = WoLolooTarget()
    @State var session: WoLolooSession = WoLolooSession()
    
    var body: some Scene {
        WindowGroup {
            ContentView(target: $target, session: $session)
                .onAppear(perform: {
                    session.loadBookmarksAndShortcuts()
                })
        }.onChange(of: scenePhase) { _, newPhase in
            onScenePhaseChanged(newPhase)
        }
    }
    
    func onScenePhaseChanged(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background: addQuickActions()
            break;
        case .inactive:
            break
        case .active:
            session.loadBookmarksAndShortcuts()
            guard let userInfo = shortcutItemToProcess?.userInfo! else {
                session.isFromShortcut = false
                return 
            }
            processQuickAction(userInfo: userInfo)
            shortcutItemToProcess = nil
            break
        @unknown default:
            break
        }
    }
    
    func processQuickAction(userInfo: [String: NSSecureCoding]) {
        do {
            // ToDo: sanitize addr and mac values
            let id = UUID(uuidString: userInfo["id"] as! String) ?? UUID()
            let name = userInfo["name"] as! String
            let addr = userInfo["addr"] as! String
            let mac = userInfo["mac"] as! String
            let port = try UInt16(userInfo["port"] as! String, format: .number)
            
            target = WoLolooTarget(id: id, name: name, addr: addr, mac: mac, port: port)
            session.isFromShortcut = true
            session.wololoo(target)
        } catch {
            
        }
    }
    func addQuickActions() {
        var items: [UIApplicationShortcutItem] = []
        if let item = session.getShortcut(0) { items.append(item) }
        if let item = session.getShortcut(1) { items.append(item) }
        if let item = session.getShortcut(2) { items.append(item) }
        if let item = session.getShortcut(3) { items.append(item) }
        if items.count > 0 {
            UIApplication.shared.shortcutItems = items
        } else {
            UIApplication.shared.shortcutItems = []
        }
    }
}
