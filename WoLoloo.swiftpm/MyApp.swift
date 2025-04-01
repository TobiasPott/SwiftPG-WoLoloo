import SwiftUI

var shortcutItemToProcess: UIApplicationShortcutItem?
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            shortcutItemToProcess = shortcutItem
        }
        
        let sceneConfiguration = UISceneConfiguration(name: "Custom Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = CustomSceneDelegate.self
        
        return sceneConfiguration
    }
}
class CustomSceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
}

@main
struct MyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var target: WoLolooTarget = WoLolooTarget()
    @State var debugTarget: WoLolooTarget? = nil
    @State var session: WoLolooSession = WoLolooSession()
    
    var body: some Scene {
        WindowGroup {
            ContentView(target: $target, session: $session)
                .onAppear(perform: {
                    session.loadBookmarks()
                })
            if let qaTarget = debugTarget {
                GroupBox(content: {
                    Text("QuickAction: \(qaTarget.name)")
                    Text("\t\t: \(qaTarget.addr)")
                    Text("\t\t: \(qaTarget.mac)")
                    Text("\t\t: \(qaTarget.port)")
                })
            }
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
            session.loadBookmarks()
            guard let userInfo = shortcutItemToProcess?.userInfo! else {
                // reset debug target if not from shortcut
                debugTarget = nil
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
            debugTarget = qaTarget
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
        }
    }
}
