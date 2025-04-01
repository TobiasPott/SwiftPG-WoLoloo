import SwiftUI

struct WoLoloTargetView: View {
    let target: WoLolooTarget
    
    var body: some View {
        let bottomPad: CGFloat = 2
        
        GroupBox(content: {
            Grid {
                GridRow(alignment: .center, content: {
                    GridLabelShort(title: "Name")
                    HStack { Text("\(target.name)"); Spacer(minLength: 0) }
                    Image(systemName: "bookmark.fill")
                }).padding(.bottom, bottomPad)
                Group {
                    GridRow(alignment: .center, content: {
                        GridLabelShort(title: "Broadcast")
                        HStack { Text("\(target.addr)") }
                    }).padding(.bottom, bottomPad)
                    GridRow(alignment: .center, content: {
                        GridLabelShort(title: "MAC")
                        HStack { Text("\(target.mac)") }
                    }).padding(.bottom, bottomPad)
                    GridRow(alignment: .center, content: {
                        GridLabelShort(title: "Port")
                        HStack { Text("\(target.port)") }
                    }).padding(.bottom, bottomPad)
                    
                    GridRow(alignment: .firstTextBaseline, content: {
                        GridLabelShort(title: "Created")
                        HStack {
                            Text(target.createdAt.formatted(date: .abbreviated, time: .shortened))
                            //                                .frame(height: 34)
                                .frame(alignment: .topLeading)
                        }
                    })
                }.gridColumnAlignment(.leading)
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
            }
            
        })
    }    
}
