import SwiftUI

struct ShortCutView: View {
    let target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    var body: some View {
        HStack {
            GridLabel(title: "Shortcut")
            HStack {
                ShortCutTargetButton(target: target, session: $session, idx: 0, baseImage: "1")
                Spacer(minLength: 0)
                ShortCutTargetButton(target: target, session: $session, idx: 1, baseImage: "2")
                Spacer(minLength: 0)
                ShortCutTargetButton(target: target, session: $session, idx: 2, baseImage: "3")
                Spacer(minLength: 0)
                ShortCutTargetButton(target: target, session: $session, idx: 3, baseImage: "4")
            }                        
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 20, weight: .regular, design: .monospaced))
        }
    }
}
