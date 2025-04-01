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
    
    var reduced: Bool = true { didSet { UserDefaults.standard.set(self.reduced, forKey: WoLolooSession.udk_reduced) } }
    
    init() {
        if UserDefaults.standard.object(forKey: WoLolooSession.udk_reduced) != nil {
            self.reduced = UserDefaults.standard.bool(forKey: WoLolooSession.udk_reduced)
        } else { UserDefaults.standard.set(self.reduced, forKey: WoLolooSession.udk_reduced) }
    }
    
    static let scItemType: String = "WoLoloo_DeviceTargetShortcut"
    func shortcutItem(_ idx: Int) -> UIApplicationShortcutItem? {
        if idx >= 0 && idx < scTargets.count, let target = scTargets[idx] { 
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
        return nil
    }
    func storeBookmarks() {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonBookmarks = String(data: try jsonEncoder.encode(bookmarks), encoding: String.Encoding.utf8)
            UserDefaults.standard.set(jsonBookmarks, forKey: WoLolooSession.udk_bookmarks)
            
            let jsonShortcuts = String(data: try jsonEncoder.encode(scTargets), encoding: String.Encoding.utf8)
            UserDefaults.standard.set(jsonShortcuts, forKey: WoLolooSession.udk_shortcuts)
            
            print("Stored bookmarks in UserDefaults")
            // ToDo: move volume store to setVolume?
            //            UserDefaults.standard.set(audio.getVolume(), forKey: WoLolooSession.udk_volume)
            //            print("Stored volume in UserDefaults")
        }
        catch {
            print("Failed to save session to UserDefaults")
        }
    }
    mutating func loadBookmarks() {
        do {
            let jsonDecoder = JSONDecoder()
            
            let jsonBookmarks: String = UserDefaults.standard.string(forKey: WoLolooSession.udk_bookmarks) ?? "[]"
            let newBookmarks = try jsonDecoder.decode([WoLolooTarget].self, from: jsonBookmarks.data(using: .utf8)!)
            self.bookmarks = newBookmarks
            
            let jsonShortcuts: String = UserDefaults.standard.string(forKey: WoLolooSession.udk_shortcuts) ?? "[nil, nil, nil, nil]"
            let newShortcuts = try jsonDecoder.decode([WoLolooTarget?].self, from: jsonShortcuts.data(using: .utf8)!)
            self.scTargets = newShortcuts
            
            //            print("Load session from UserDefaults")
        }
        catch {
            print("Failed to load session from UserDefaults")
        }
    }
    func isBookmarked(_ target: WoLolooTarget) -> Bool {
        return self.bookmarks.contains(where: { bm in
            return bm == target //(bm.name == target.name && bm.mac == target.mac && bm.addr == target.addr) || bm.id == target.id
        })
    }
    mutating func wololoo(_ target: WoLolooTarget) {
        print("WoLoloo")
        let req = target.wakeup()
        self.audio.play()
        self.history.append(req)
    }
    mutating func bookmark(_ target: WoLolooTarget) {  
        if !isBookmarked(target) {
            var newBookmark = target
            newBookmark.createdAt = .now
            self.bookmarks.append(newBookmark)
            self.storeBookmarks()
            //            print("Bookmarked")
        } else {
            //            print("Already bookmarked")
            self.bookmarks.removeAll { bm in bm.id == target.id }
            var newBookmark = target
            newBookmark.createdAt = .now
            self.bookmarks.append(newBookmark)
            self.storeBookmarks()
        }
    }
}
