import SwiftUI

extension WoLolooSession {
    func storeBookmarksAndShortcuts() {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonBookmarks = String(data: try jsonEncoder.encode(bookmarks), encoding: String.Encoding.utf8)
            UserDefaults.standard.set(jsonBookmarks, forKey: WoLolooSession.udk_bookmarks)
            
            let jsonShortcuts = String(data: try jsonEncoder.encode(scTargets), encoding: String.Encoding.utf8)
            UserDefaults.standard.set(jsonShortcuts, forKey: WoLolooSession.udk_shortcuts)
            print("Stored bookmarks in UserDefaults")
        }
        catch {
            print("Failed to save session to UserDefaults")
        }
    }
    mutating func loadBookmarksAndShortcuts() {
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
}
