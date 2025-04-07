import SwiftUI

struct ImageIf: View {
    enum Category {
        case info, warn, error
    }
    static let categoryColors: [Category: Color] = [.info: .white, .warn: .orange, .error: .red]
    
    let set: Bool
    var category: Category = .info
    
    var image: String = "exclamationmark.triangle"
    
    var body: some View {
//        Image(systemName: "exclamationmark")
//        Image(systemName: "exclamationmark.message")
//        Image(systemName: "exclamationmark.bubble")
//        Image(systemName: "exclamationmark.circle")
        if set {
            Image(systemName: image)
                .foregroundStyle(ImageIf.categoryColors[category]!) 
        }
    }
}
