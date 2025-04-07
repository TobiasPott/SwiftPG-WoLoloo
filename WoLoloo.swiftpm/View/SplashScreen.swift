import SwiftUI

struct SplashScreen: View {
    let onClose: () -> Void
    
    var body: some View {
        GroupBox(content: {
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Wake\nOn")
                        .font(.largeTitle).fontWeight(.bold)
                        .fontDesign(.monospaced)
                    HStack(alignment: .firstTextBaseline) {
                        Text("LAN")                        
                            .font(.largeTitle).fontWeight(.bold)
                            .fontDesign(.monospaced)
                        Text("oloo")
                            .fontDesign(.monospaced)
                        Spacer()
                        
                        Text("v \(MyApp.getVersion())")
                            .fontDesign(.monospaced)   
                        
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 32)
                .background(.black.opacity(0.25))
                
                
                ScrollView(content: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Prerequisites")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                        Text("* WoLoloo requires access to your local network for it's main functionality.\n* You need a Wake-On-LAN enabled and conigured device.")
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .padding(.bottom)
                        
                        Text("Privacy")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                        Text("* WoLoloo uses IP (Internet Protocol) and MAC address information when used. This information might be visible to others on your network (e.g. public wifi).")
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                        
                        Button("Accept", action: { withAnimation { onClose() } })
                            .fontDesign(.monospaced)
                            .padding(.top)
                        Text("(Don't accept, if you are not okay with the above.)")                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                    }
                }).frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
                    .background(.black.opacity(0.25))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        })
        //        .font(.system(size: 15, weight: .regular, design: .monospaced))
    }
}
