import SwiftUI

struct HistoryView: View {
    @Binding var session: WoLolooSession
    
    var body: some View {
        GroupBox(content: {
            // ToDo: add .onDelete handler to list
            NavigationLink("Session History (\(session.history.count))", destination: {
                GroupBox(content: {
                    List{
                        ForEach($session.history) { $item in 
                            Text("\(item.target.mac) (\(item.target.multicastAddr)")
                        }
                    }.listStyle(.plain)
//                        .frame(maxHeight: 240).padding(.horizontal, -16)
                })
                .navigationTitle("Session History")
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                Spacer()    
            })
            .frame(maxWidth: .infinity, alignment: .leading)
        })
    }   
}
