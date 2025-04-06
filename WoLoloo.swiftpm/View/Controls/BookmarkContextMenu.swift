import SwiftUI

struct BookmarkContextMenu: View {
    @Environment(\.dismiss) private var dismiss
    
    let bookmark: WoLolooTarget
    @Binding var target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    var body: some View {
        Button("Duplicate") {
            target = bookmark.duplicate()
            session.bookmark(target)
        }
        // ToDo: Consider adding 'shortcut' options to the context menu to allow assigning devices as such in bookmarks (requires validation)
        Button("Validate") {
            //                                target = bm.duplicate()
            //                                session.bookmark(target)
        }
    }
}
