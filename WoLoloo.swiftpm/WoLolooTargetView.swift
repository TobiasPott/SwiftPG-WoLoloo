import SwiftUI

struct WoLoloTargetControl: View {
    // ToDo: Consider consolidation of trget control and view with an 'edit' flag (or overload init where binding makes it edit and not binding makes it view (would be cool to check)
    @Binding var target: WoLolooTarget
    let isBookmarked: Bool
    
    var body: some View {
        // Editable target view
        Grid {
            PropertyGridRow(title: "Name", content: {
                TextField("Descriptive Name", text: $target.name).foregroundStyle(Color.accentColor)
                Image(systemName: isBookmarked ? "bookmark" : "bookmark.fill").foregroundStyle(Color.accentColor)
            })
            PropertyGridRow(title: "Broadcast", content: {
                TextField("Broadcast IP/Host Name", text: $target.addr)
                ImageIf(set: !target.isValidAddr)
            })
            PropertyGridRow(title: "MAC", content: {
                TextField("Wake-On-Lan MAC Address", text: $target.mac)
                    .onChange(of: target.mac, {
                        target.mac = target.mac.replacingOccurrences(of: "-", with: ":")
                    })
                ImageIf(set: !target.isValidMac)
            })
            // ToDo: check bug in changing port value (resets to default of 9)
            PropertyGridRow(title: "Port", content: {
                TextField("Port (default = 9)", value: $target.port, formatter: NumberFormatter())
                ImageIf(set: target.port != 9, image: "exclamationmark.circle")
            })
            
            PropertyGridRow(title: "Created", content: {
                let createdAtStr = target.createdAt.formatted(date: .abbreviated, time: .shortened)
                Text(createdAtStr)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            })
        }
    }    
}


struct WoLoloTargetView: View {
    let target: WoLolooTarget    
    let isBookmarked: Bool
    
    var body: some View {
        // View-only target view
        GroupBox(content: {
            Grid {
                PropertyGridRow(title: "Name", content: {
                    Text("\(target.name)").foregroundStyle(Color.accentColor)
                    Image(systemName: isBookmarked ? "bookmark" : "bookmark.fill").foregroundStyle(Color.accentColor)
                }, short: true)
                Group {
                    PropertyGridRow(title: "Broadcast", content: {
                        Text("\(target.addr)")
                        ImageIf(set: !target.isValidAddr)
                    })
                    PropertyGridRow(title: "MAC", content: {
                        Text("\(target.mac)")
                        ImageIf(set: !target.isValidMac)
                    })
                    PropertyGridRow(title: "Port", content: {
                        Text("\(target.port)") 
                        ImageIf(set: target.port != 9)
                    })
                    PropertyGridRow(title: "Created", content: {
                        let createdAtStr = target.createdAt.formatted(date: .abbreviated, time: .shortened)
                        Text(createdAtStr)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    })
                }.gridColumnAlignment(.leading)
                    .font(.system(size: 10, weight: .regular, design: .monospaced))
            }
            
        })
    }    
}
