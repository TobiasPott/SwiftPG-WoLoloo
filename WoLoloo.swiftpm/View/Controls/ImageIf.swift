import SwiftUI

struct ImageIf: View {
    let set: Bool
    var image: String = "exclamationmark.triangle"
    
    var body: some View {
        if set { Image(systemName: image).foregroundStyle(.yellow) }
    }
}
