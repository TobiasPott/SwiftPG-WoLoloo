import SwiftUI

struct PropertyGridRow<Content: View>: View {
    var title: String = "Title"
    
    @ViewBuilder var content: () -> Content
    var short: Bool = false
    
    var body: some View {
        let bottomPad: CGFloat = 2
        
        GridRow(alignment: .firstTextBaseline, content: {
            if short { GridLabelShort(title: title) }
            else { GridLabel(title: title) }
            content()
        }).padding(.bottom, bottomPad)
    }
}
