import SwiftUI

struct WoLolooSession {
    static let udk_bookmarks = "wololoo_bookmarks"
    static let udk_shortcuts = "wololoo_shortcuts"
    static let udk_volume = "wololoo_volume"
    static let udk_muted = "wololoo_muted"
    static let udk_reduced = "wololoo_reduced"
    
    var history: [WoLolooTarget.Request] = []
    var bookmarks: [WoLolooTarget] = []
    var scTargets: [WoLolooTarget?] = [nil, nil,nil, nil]
    var audio: WoLolooAudio = WoLolooAudio()    
    var isFromShortcut: Bool = false
    
    var reduced: Bool = true { didSet { UserDefaults.standard.set(self.reduced, forKey: WoLolooSession.udk_reduced) } }
    
    init() {
        if UserDefaults.standard.object(forKey: WoLolooSession.udk_reduced) != nil {
            self.reduced = UserDefaults.standard.bool(forKey: WoLolooSession.udk_reduced)
        } else { UserDefaults.standard.set(self.reduced, forKey: WoLolooSession.udk_reduced) }
        self.isFromShortcut = false
    }
    
    static let scItemType: String = "WoLoloo_DeviceTargetShortcut"
    func shortcutItem(_ idx: Int) -> UIApplicationShortcutItem? {
        if idx >= 0 && idx < scTargets.count {
            if let target = scTargets[idx] { 
                let scItem = UIMutableApplicationShortcutItem(type: WoLolooSession.scItemType, localizedTitle: "Empty")
                scItem.type = WoLolooSession.scItemType // (REQUIRED)
                scItem.localizedTitle = "Wake up '\(target.name)'" // (REQUIRED
                scItem.icon = UIApplicationShortcutIcon(type: .bookmark) // icon of shortcut
                var calluserInfo: [String: NSSecureCoding] {
                    return ["name" : "\(target.name)" as NSSecureCoding,
                            "addr": "\(target.addr)" as NSSecureCoding, 
                            "mac": "\(target.mac)" as NSSecureCoding, 
                            "port": "\(target.port)" as NSSecureCoding]
                }
                scItem.userInfo = calluserInfo
                return scItem
            } 
        }
        return nil
    }
    
    
    func isBookmarked(_ target: WoLolooTarget) -> Bool {
        return self.bookmarks.contains(where: { bm in
            return bm == target
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
            // print("Already bookmarked")
            self.bookmarks.removeAll { bm in bm.id == target.id }
        }
        var newBookmark = target
        newBookmark.createdAt = .now
        self.bookmarks.append(newBookmark)
        self.storeBookmarksAndShortcuts()
        self.isFromShortcut = false
    }
}
