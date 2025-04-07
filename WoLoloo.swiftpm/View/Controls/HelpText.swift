import SwiftUI

public enum HelpEntry: Int {
    case none, name, broadcast, mac, port, created, shortcut, new_obsolete, save, wololoo, bookmarks, volume, help, about, sourceCode
}
struct HelpText: Identifiable {
    public let id: HelpEntry
    let title: String
    let content: String
}
struct HelpTextView: View {
    let helpText: HelpText
    
    var body: some View {
        if helpText.id == .none {
            EmptyView().id(helpText.id)
        } else {
            GroupBox(helpText.title) { Text(helpText.content).frame(maxWidth: .infinity, alignment: .leading) }.id(helpText.id)
        }
    }
}

struct Help {
    static let helpTexts: [HelpText] = [
        .init(id: .none, title: "", content: ""),
        .init(id: .name, title: "Name", content: "Give your device a descriptive name. It helps you to identify all your devices in an simple way (e.g.: use your PC's name)"),
        .init(id: .broadcast, title: "Broadcast", content: "The broadcast IP address or host name is used to send the broadcast package to. \nUse your target device's or its subnet's address and formt it like '192.168.1.77'. You can replace an address block with an asterisk '*' which will internally be swapped with '255' to broaden the address range. \n\nYou should be able to use a host name, though I didn't test that thouroughly. (Please give me your feedback if you do)."),
        .init(id: .mac, title: "MAC", content: "Wake-On-Lan requires your device's MAC address. You can find them in your device's network adapter settings. It is usually formatted like '01-23-45-67-89-0A' or '01:23:45:67:89:0A'. \nWoLoloo expects colon separation but will convert hyphens you may enter. \n\nTry 'ipconfig' in a Windows command line or 'ifconfig' on Linux or Mac systems. \n\nYou may need to configure your device's network and BIOS settings to allow Wake-On-LAN, check the internet for some guides on your specific device."),
        .init(id: .port, title: "Port", content: "The network port used to send the magic packet to. It defaults to 9 and is configurable in case you have other requirements."),
        .init(id: .created, title: "Created At", content: "The date and time the WoLoloo device target was created. This value cannot be edited and is set upon bookmarking. \nIt is currently not in use but may be used in future features."),
        .init(id: .shortcut, title: "Shortcut", content: "Shortcuts allows you to set four of your devices to be available from your devices homesceen. Long-press the 'WoLoloo' app icon to wake up the shortcut devices from the quick actions.\n\nYou need to specify 'Broadcast' and 'MAC' to use a device in a shortcut."),
        .init(id: .new_obsolete, title: "New", content: "Clears the configuration and allows you to create a new device target."),
        .init(id: .save, title: "Save", content: "Saves the current configuration as a device target into your bookmarks. Save a configuration if you need it the next time you open this app."),
        .init(id: .wololoo, title: "WoLoloo", content: "This is when the magic happens. WoLoloo will send a magic package for the displayed configuration to wake up the device over the network. \nThe name WoLoloo is a silly reference, I like a bit too much, to a game unit in Age of Empires 2, which yells out 'WoLoloo', maybe some will remember."),
        .init(id: .bookmarks, title: "Bookmarks", content: "Your list of bookmarked device targets. This list is saved as your user data and will be present next time you start up the app. \nPlease note, you can save your configurations to avoid re-entering all values. I want WoLoloo to store as little data as possible but allow me to make my life a wee bit easier. \n\nIf you need more management options, please look for Mocha WOL, WoloW and others."),
        .init(id: .volume, title: "Volume", content: "Well, WoLoloo yells out when it sends the magic package. You can set the volume if you prefer silent mode."),
        .init(id: .help, title: "Help", content: "The section where you find all information about the different parts of the application"),
        .init(id: .about, title: "About", content: "WoLoloo is an app to send a magic package to Wake-On-LAN enabled devices in my local network. Of course there are other tools which do the job (and which I used to validate mine working) and they perform a grat job. \nI wanted to better understand how Wake-On-LAN works and what is necessary to implement it in an application. WoLoloo is the result of my small adventure with Wake-On-LAN. \n\nYou may find the yell familiar, and if so it might by from the game Age of Empires 2. The game's monk unit uses the 'Wololoo' yell, which became this apps name saint. \n\nTake a second and remember"),
        //        .init(id: .sourceCode, title: "Source", content: "<WIP>"),
    ]
    
}
