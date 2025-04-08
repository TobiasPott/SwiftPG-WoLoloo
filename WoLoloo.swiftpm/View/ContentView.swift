import SwiftUI

struct ContentView: View {
    @Binding var target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    @Binding var hideSplashScreen: Bool
    
    var body: some View {
        if !hideSplashScreen {
            SplashScreen(onClose: {
                self.hideSplashScreen.toggle()
                Persist.writeBool(key: .splashscreen, value: self.hideSplashScreen)
                
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Persist.writeString(key: .version, value: appVersion)
                }
            }).transition(.move(edge: .top))
        }
        else {
            NavigationStack(root: {
                let isValid = target.isValid
                SessionAppToolbar(target: $target, session: $session)
                    .navigationTitle("WoLoloo")
                GroupBox(content: {
                    if session.isFromShortcut {
                        Text("Loaded Shortcut")
                            .foregroundStyle(Color.accentColor)
                    }
                    let bindTarget = $session.bookmarks.first { bm in
                        return bm.id == target.id
                    } ?? $target
                    WoLoloTargetControl(target: bindTarget, isBookmarked: !session.isBookmarked(target))
                })
                GroupBox(content: {
                    ShortCutView(target: target, session: $session)
                        .disabled(!isValid)
                })
                GroupBox(content: {
                    Grid {
                        GridRow(alignment: .center, content: {
                            Button("Save") { session.bookmark(target) }
                            Button("WoLoloo") { session.wololoo(target) }
                                .disabled(!isValid)
                        })       
                        .frame(maxWidth: .infinity)
                    }                
                })
                if !session.reduced {
                    ScrollView {
                        WoLolooAudioView(target: $session.audio)
                        BookmarksLink(target: $target, session: $session)
                        GettingStartedLink()                        
                    }
                    .padding(.top).padding(.top)
                } else { Spacer() }
                
                SourceCodeLink(reduced: session.reduced)
                    .padding(.bottom)
            })
            .padding(.horizontal)
            .font(.system(size: 14, weight: .regular, design: .monospaced))
        }
    }
}
