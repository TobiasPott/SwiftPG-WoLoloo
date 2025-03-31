import SwiftUI

struct ContentView: View {
    @State var target: WoLolooTarget = WoLolooTarget()
    @State var session: WoLolooSession = WoLolooSession()
    
    var body: some View {
        NavigationStack(root: {
            VStack() {
                if session.reduced {
                    GroupBox(content: {
                        HStack(spacing: 16) {
                            Button(action: { withAnimation { session.reduced.toggle() } }, label: {
                                Image(systemName: "widget.extralarge")
                            })
                            Spacer(minLength: 0)
                            BookmarksLink(target: $target, session: $session, reduced: true)
                            Spacer(minLength: 0)
                            GettingStartedLink(reduced: true)
                            Spacer(minLength: 0)
                            WoLolooAudioControls(target: $session.audio)
                        }.frame(maxWidth: .infinity, maxHeight: 16)
                    }).frame(minHeight: 32)
                } else { 
                    HStack() {
                        GroupBox(content: {
                            
                            Button(action: { withAnimation { session.reduced.toggle() } }, label: {
                                Image(systemName: "widget.small")
                            }).frame(maxHeight: 16)
                        })
                        Spacer()
                    }.frame(maxWidth: .infinity)
                }
                GroupBox(content: {
                    WoLoloTargetControl(target: $target, isBookmarked: !session.isBookmarked(target))
                })
                GroupBox(content: {
                    Grid {
                        let isValid = target.isValid
                        GridRow(alignment: .center, content: {
                            Button("New") { target = WoLolooTarget() }
                            Button("Save") { session.bookmark(target) }
                            Button("WoLoloo") { session.wololoo(target) }
                        })       
                        .disabled(!isValid)
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
        .onAppear(perform: {
            session.loadBookmarks()
        })
    }
}
