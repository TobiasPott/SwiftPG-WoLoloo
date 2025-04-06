import SwiftUI

struct ContentView: View {
    @Binding var target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    var body: some View {
        NavigationStack(root: {
            VStack() {
                let isValid = target.isValid
                SessionAppToolbar(target: $target, session: $session)
                GroupBox(content: {
                    if session.isFromShortcut {
                        Text("Loaded Shortcut").foregroundStyle(Color.accentColor)
                    }
                    WoLoloTargetControl(target: $target, isBookmarked: !session.isBookmarked(target))
                })
                GroupBox(content: {
                    ShortCutView(target: target, session: $session)                                .disabled(!isValid)
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
                    VStack {
                        ScrollView {
                            WoLolooAudioView(target: $session.audio)
                            BookmarksLink(target: $target, session: $session)
                            GettingStartedLink()                        
                            // ToDo: re-enable history when a proper display view is done (not really displaying any useful info atm)
                            //                        HistoryView(session: $session)
                        }
                    }
                    .padding(.top).padding(.top)
                } else { 
                    Spacer()
                }
            }
            .navigationTitle("WoLoloo")
            
        })
        .padding(.horizontal)
        .font(.system(size: 14, weight: .regular, design: .monospaced))
        .frame(maxWidth: 440)
        
    }
}
