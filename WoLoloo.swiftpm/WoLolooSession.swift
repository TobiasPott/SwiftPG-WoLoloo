import SwiftUI

struct WoLolooSession {
    var history: [WoLolooTarget.Request] = []
    var bookmarks: [WoLolooTarget] = []
    var shortcuts: [WoLolooTarget?] = [nil, nil,nil, nil]
    var audio: WoLolooAudio = WoLolooAudio()    
    var isFromShortcut: Bool = false
    
    var reduced: Bool = true { didSet { Persist.writeBool(key: .reduced, value: self.reduced) } }
    
    init() {
        self.reduced = Persist.getBool(key: .reduced, self.reduced)
        self.isFromShortcut = false
    }
    
    func getShortcut(_ idx: Int) -> UIApplicationShortcutItem? {
        let shortcutItemType: String = "WoLoloo_DeviceTargetShortcut"
        
        if idx < 0 && idx >= shortcuts.count { return nil }
        if let target = shortcuts[idx] { 
            let scItem = UIMutableApplicationShortcutItem(type: shortcutItemType, localizedTitle: "Wake up '\(target.name)'")
            scItem.icon = UIApplicationShortcutIcon(type: .message) // icon of shortcut
            scItem.userInfo = target.userInfo
            return scItem
        } 
        return nil
    }
    
    
    func isBookmarked(_ target: WoLolooTarget) -> Bool {
        return self.bookmarks.contains(where: { bm in
            return bm.id == target.id
        })
    }
    mutating func wololoo(_ target: WoLolooTarget) {
        print("WoLoloo")
        let req = target.wakeup()
        self.audio.play()
        self.history.append(req)
    }
    mutating func bookmark(_ target: WoLolooTarget) {  
        if isBookmarked(target) {
            //            print("Already bookmarked")
        } else {
            var newBookmark = target
            newBookmark.createdAt = .now
            self.bookmarks.append(newBookmark)
        }
        _ = Persist.writeJSON(key: .bookmarks, self.bookmarks)
        self.isFromShortcut = false
    }
}

extension WoLolooSession {
    //    func storeBookmarksAndShortcuts() {
    //        _ = Persist.writeJSON(key: .bookmarks, self.bookmarks)
    //        _ = Persist.writeJSON(key: .shortcuts, self.shortcuts)
    //    }
    mutating func loadBookmarksAndShortcuts() {
        self.bookmarks = Persist.getJSON(key: .bookmarks, [])
        self.shortcuts = Persist.getJSON(key: .shortcuts, [nil, nil, nil, nil])
    }
}
