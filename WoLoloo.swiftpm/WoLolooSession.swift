import SwiftUI

struct WoLolooSession {
    static let udk_bookmarks = "wololoo_bookmarks"
    static let udk_volume = "wololoo_volume"
    static let udk_muted = "wololoo_muted"
    static let udk_reduced = "wololoo_reduced"
    
    var history: [WoLolooTarget.Request] = []
    var bookmarks: [WoLolooTarget] = []
    var audio: WoLolooAudio = WoLolooAudio()
    var reduced: Bool = true { didSet { UserDefaults.standard.set(self.reduced, forKey: WoLolooSession.udk_reduced) } }
    
    init() {
        if UserDefaults.standard.object(forKey: WoLolooSession.udk_reduced) != nil {
            self.reduced = UserDefaults.standard.bool(forKey: WoLolooSession.udk_reduced)
        } else { UserDefaults.standard.set(self.reduced, forKey: WoLolooSession.udk_reduced) }
    }
    
    
    func storeBookmarks() {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(bookmarks)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            UserDefaults.standard.set(json, forKey: WoLolooSession.udk_bookmarks)
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
            let jsonBookmarks: String = UserDefaults.standard.string(forKey: WoLolooSession.udk_bookmarks) ?? "[]"
            let jsonDataBookmarks = jsonBookmarks.data(using: .utf8)!
            let jsonDecoder = JSONDecoder()
            let newBookmarks = try jsonDecoder.decode([WoLolooTarget].self, from: jsonDataBookmarks)
            self.bookmarks = newBookmarks
            //            print("Load session from UserDefaults")
        }
        catch {
            print("Failed to load session from UserDefaults")
        }
    }
    func isBookmarked(_ target: WoLolooTarget) -> Bool {
        return self.bookmarks.contains(where: { bm in
            return (bm.name == target.name && bm.mac == target.mac && bm.multicastAddr == target.multicastAddr) || bm.id == target.id
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
