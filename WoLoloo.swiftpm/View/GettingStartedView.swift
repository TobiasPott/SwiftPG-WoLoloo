import SwiftUI

struct GettingStartedIcon: View {
    var body: some View {
        Image(systemName: "questionmark.circle")
            .resizable().aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
    }
}
struct GettingStartedLink: View {
    var scrollTarget: HelpEntry = .none
    var reduced: Bool = false
    
    var body: some View {
        if reduced {
            NavigationLink(destination: {
                GettingStartedView(scrollTarget: scrollTarget)
            }, label: {
                GettingStartedIcon()
            })
        } else {
            GroupBox(content: {
                NavigationLink(destination: {
                    GettingStartedView(scrollTarget: scrollTarget)
                }, label: { 
                    GettingStartedIcon().padding(.trailing)
                    Text("Help") 
                })
                .frame(maxWidth: .infinity)
            })
        }
    }
}
struct GettingStartedView: View {
    var scrollTarget: HelpEntry = .none
    
    var body: some View {
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
    }
}
