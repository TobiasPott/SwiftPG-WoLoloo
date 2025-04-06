import SwiftUI

struct ShortCutTargetButton: View {
    let target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    var idx: Int = 0
    var baseImage: String = "0"
    var onVariant: String = ".square.fill"
    var offVariant: String = ".square"
    
    var body: some View {
        let isSC = session.scTargets[idx] == nil ? false : (target == session.scTargets[idx]!)
        Button("", systemImage: baseImage + (isSC ? onVariant : offVariant), 
               action: {
            if isSC { session.scTargets[idx] = nil } 
            else { session.scTargets[idx] = target } 
            session.storeBookmarksAndShortcuts()
        })
    }
}
