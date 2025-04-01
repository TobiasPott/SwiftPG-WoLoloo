import SwiftUI

struct SessionAppToolbar: View {
    @Binding var target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    var body: some View {
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
       
    }
}
