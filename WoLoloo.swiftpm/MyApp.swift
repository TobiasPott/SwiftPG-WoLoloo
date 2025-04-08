import SwiftUI

@main
struct MyApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var target: WoLolooTarget = WoLolooTarget()
    @State var session: WoLolooSession = WoLolooSession()
    @State var hideSplashScreen = Persist.getBool(key: .splashscreen, false)
    
    var body: some Scene {
        WindowGroup {
            ContentView(target: $target, session: $session, hideSplashScreen: $hideSplashScreen)
                .onAppear(perform: {
                    session.loadBookmarksAndShortcuts()
                    let lastVersion = Persist.getString(key: .version, "0.x")
                    if lastVersion != MyApp.getVersion() {
                        Persist.writeBool(key: .splashscreen, value: false)
                        hideSplashScreen = false
                    }
                })
                .frame(maxWidth: 440)    
        }.onChange(of: scenePhase) { _, newPhase in
            onScenePhaseChanged(newPhase)
        }
    }
    
    static func getVersion() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String { return appVersion
        } else { 
            return "0.?"
        }
    }
}
