import SwiftUI

struct SourceCodeLink: View {
    var reduced: Bool = false
    
    var body: some View {
        
        GroupBox(content: {
            if reduced {
                NavigationLink(destination: {
                    SourceCodeView()
                }, label: {
                    Image(systemName: "curlybraces.square.fill")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 23)
                })
            } else {
                NavigationLink(destination: {
                    SourceCodeView()
                }, label: { Text("Source Code") })
                .frame(maxWidth: .infinity)
            }
        })
        
    }
}

struct SourceCodeView: View {
    
    // ToDo: add link to project source code
    // https://github.com/TobiasPott/SwiftPG-WoLoloo    
    var body: some View {
        GroupBox(content: {
            VStack(alignment: .leading, spacing: 10) {
                Text("FOSS")
                    .font(.headline).fontDesign(.monospaced)
                VStack(alignment: HorizontalAlignment.leading) {
                    Text("WoLoloo is a free and open source software. It is made with the intent to share knowledge and joy with others and give you everything necessary to derive it and do whatever you see fit.")
                    Text("The original app is written in Swift using the SwiftPlayground app. The full source code is available on github for anyone to use.")
                }.padding(.bottom)
                
                Text("Source Code")
                    .font(.headline).fontDesign(.monospaced)
                Text("WoLoloo is build from a single repository which contains all source code and assets.")
                HStack {
                    Text("Visit WoLoloo")
                    Link(destination: URL(string: "https://github.com/TobiasPott/SwiftPG-WoLoloo/")!, label: {
                        Text("on Github")
                        Image(systemName: "link")
                    })
                }.padding(.bottom)
                
                Text("References & Resources")
                    .font(.headline).fontDesign(.monospaced)
                Text("WoLoloo uses the following resources and references:")
                DisclosureGroup("Awake by Jesper Lindber") {
                    Text("The Dall-E powered Bing Image Creator is used to create some of the provided samples and graphics.")
                    HStack {
                        Spacer(); Link("Visit Website", destination: URL(string: "https://github.com/jesper-lindberg/Awake")!)
                    }
                }
            }
        })
        .navigationTitle("Source Code")
        .font(.system(size: 14, weight: .regular, design: .monospaced))
        Spacer()
    }
}


