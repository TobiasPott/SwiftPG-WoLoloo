import SwiftUI

struct BookmarksLink: View {
    @Binding var target: WoLolooTarget
    @Binding var session: WoLolooSession
    var reduced: Bool = false
    
    var body: some View {
        if reduced {
            NavigationLink(destination: {
                BookmarksView(target: $target, session: $session)                
            }, label: { Image(systemName: "bookmark") })
        } else {
            GroupBox(content: {
                NavigationLink(destination: {
                    BookmarksView(target: $target, session: $session)
                }, label: { Text("Bookmarks (\(session.bookmarks.count))") })
                .frame(maxWidth: .infinity)
            })
        }
    }
}

struct BookmarksView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var target: WoLolooTarget
    @Binding var session: WoLolooSession
    
    var body: some View {
        GroupBox(content: {
            Text("Select a bookmark").frame(maxWidth: .infinity, alignment: .leading)
            List{
                ForEach($session.bookmarks) { $bm in
                    
                    Button(action: { 
                        target = bm
                        dismiss()
                    }, label: { 
                        WoLoloTargetView(target: bm).padding(.horizontal, -16) 
                    })
                }.onDelete(perform: { indexSet in 
                    session.bookmarks.remove(atOffsets: indexSet)
                    // store changed session to UserDefaults
                    session.storeBookmarks()
                })
            }
            .listStyle(.inset)
            .padding(.horizontal, -16)
        })
        .navigationTitle("Bookmarks")
        .font(.system(size: 14, weight: .regular, design: .monospaced))
        Spacer()
    }
}
