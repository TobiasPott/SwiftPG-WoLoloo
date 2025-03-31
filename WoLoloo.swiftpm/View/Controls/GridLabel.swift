import SwiftUI

struct GridLabel: View {
    let title: any StringProtocol
    var width: CGFloat = 100
    
    var body: some View {
        Text(title)
            .fontWeight(.black)
            .gridColumnAlignment(.leading)
            .frame(maxWidth: width, alignment: .leading)
    }
}

struct GridLabelShort: View {
    let title: any StringProtocol
    var body: some View {
        GridLabel(title: title, width: 80)        
    }
}
