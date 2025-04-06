import SwiftUI

struct BookmarksLink: View {
    @Binding var target: WoLolooTarget
    @Binding var session: WoLolooSession
    var reduced: Bool = false
    
    var body: some View {
        if reduced {
            NavigationLink(destination: {
                BookmarksView(target: $target, session: $session)                
            }, label: {
                Image(systemName: "list.bullet.rectangle")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 23)
                    .overlay(content: {
                        Image(systemName: "bookmark.fill")
                            .offset(CGSize(width: 10.0, height: 6.0))
                    })
            })
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
            HStack {
                
                Button("Create Device Target") {
                    target = WoLolooTarget()
                    session.bookmark(target)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            List{
                ForEach($session.bookmarks) { $bm in
                    Button(action: {
                        session.isFromShortcut = false
                        target = bm
                        dismiss()
                    }, label: { 
                        WoLoloTargetView(target: bm, isBookmarked: true).padding(.horizontal, -16)
                        .contextMenu {
                            Button("Duplicate") {
                                target = bm.duplicate()
                                session.bookmark(target)
                            }
                            // ToDo: Consider adding 'shortcut' options to the context menu to allow assigning devices as such in bookmarks (requires validation)
                            Button("Validate") {
//                                target = bm.duplicate()
//                                session.bookmark(target)
                            }
                        }
                    })
                }.onDelete(perform: { indexSet in 
                    session.bookmarks.remove(atOffsets: indexSet)
                    // store changed session to UserDefaults
                    session.storeBookmarksAndShortcuts()
                })
            }
            .listStyle(.inset)
            .padding(.horizontal, -15)
        })
        .navigationTitle("Bookmarks")
        .font(.system(size: 14, weight: .regular, design: .monospaced))
        Spacer()
    }
}
