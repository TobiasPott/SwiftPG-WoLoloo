import SwiftUI

@main
struct MyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var target: WoLolooTarget = WoLolooTarget()
    //    @State var debugTarget: WoLolooTarget? = nil
    @State var session: WoLolooSession = WoLolooSession()
    
    var body: some Scene {
        WindowGroup {
            
            ContentView(target: $target, session: $session)
                .onAppear(perform: {
                    session.loadBookmarksAndShortcuts()
                })
            //            if let qaTarget = debugTarget {
            //                GroupBox(content: {
            //                    Text("QuickAction: \(qaTarget.name)")
            //                    Text("\t\t: \(qaTarget.addr)")
            //                    Text("\t\t: \(qaTarget.mac)")
            //                    Text("\t\t: \(qaTarget.port)")
            //                })
            //            }
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
                // reset debug target if not from shortcut
                //                debugTarget = nil
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
            var qaTarget = WoLolooTarget()
            // ToDo: sanitize addr and mac values
            qaTarget.name = userInfo["name"] as! String
            qaTarget.addr = userInfo["addr"] as! String
            qaTarget.mac = userInfo["mac"] as! String
            qaTarget.port = try UInt16(userInfo["port"] as! String, format: .number)
            // ToDo: Remove debug variable
            //            debugTarget = qaTarget
            session.isFromShortcut = true
            target = qaTarget
            session.wololoo(qaTarget)
        } catch {
            
        }
    }
    func addQuickActions() {
        var shortcutItems: [UIApplicationShortcutItem] = []
        if let scItem = session.shortcutItem(0) { shortcutItems.append(scItem) }
        if let scItem = session.shortcutItem(1) { shortcutItems.append(scItem) }
        if let scItem = session.shortcutItem(2) { shortcutItems.append(scItem) }
        if let scItem = session.shortcutItem(3) { shortcutItems.append(scItem) }
        if shortcutItems.count > 0 {
            UIApplication.shared.shortcutItems = shortcutItems
        } else {
            UIApplication.shared.shortcutItems = []
        }
    }
}
