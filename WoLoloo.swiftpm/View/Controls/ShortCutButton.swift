import SwiftUI

struct ShortCutTargetButton: View {
    let target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    var idx: Int = 0
    var baseImage: String = "0"
    var onVariant: String = ".square.fill"
    var offVariant: String = ".square"
    
    var body: some View {
        let isSC = session.shortcuts[idx] == nil ? false : (target == session.shortcuts[idx]!)
        Button("", systemImage: baseImage + (isSC ? onVariant : offVariant), 
               action: {
            if isSC { session.shortcuts[idx] = nil } 
            else { session.shortcuts[idx] = target } 
            _ = Persist.writeJSON(key: .shortcuts, session.shortcuts)
        })
    }
}
