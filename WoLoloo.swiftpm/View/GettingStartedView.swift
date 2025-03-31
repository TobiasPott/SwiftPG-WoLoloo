import SwiftUI

struct GettingStartedLink: View {
    var scrollTarget: HelpEntry = .none
    var reduced: Bool = false
    
    var body: some View {
        if reduced {
            NavigationLink(destination: {
                GettingStartedView(scrollTarget: scrollTarget)                
            }, label: { Image(systemName: "questionmark.circle") })
        } else {
            GroupBox(content: {
                NavigationLink(destination: {
                    GettingStartedView(scrollTarget: scrollTarget)
                }, label: { Text("Help") })
                .frame(maxWidth: .infinity)
            })
        }
    }
}
struct GettingStartedView: View {
    var scrollTarget: HelpEntry = .none
    
    var body: some View {
//        GroupBox(content: {
//            NavigationLink("Help", destination: {
//                
                ScrollViewReader { svReader in
                    ScrollView {
                        ForEach(Help.helpTexts) { ht in
                            HelpTextView(helpText: ht).padding(.bottom)
                        }
                    }
                    .onAppear(perform: { svReader.scrollTo(scrollTarget) })
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                .navigationTitle("Help")
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                Spacer()
//            })
//            .frame(maxWidth: .infinity)
//        })
    }
}
