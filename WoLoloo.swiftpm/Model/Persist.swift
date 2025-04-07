import SwiftUI

struct Persist {
    enum Keys: String {
        case bookmarks = "wololoo_bookmarks"
        case shortcuts = "wololoo_shortcuts"
        case volume = "wololoo_volume"
        case muted = "wololoo_muted"
        case reduced = "wololoo_reduced"
        case splashscreen = "wololoo_splashscreen"
    }
    
    
    // = = = = = = = = = = =
    // Bool type get/write
    // = = = = = = = = = = =
    static func getBool(key: Keys, _ defaultValue: Bool = false) -> Bool {
        if UserDefaults.standard.object(forKey: key.rawValue) != nil {
            return UserDefaults.standard.bool(forKey: key.rawValue)
        } else { 
            UserDefaults.standard.set(defaultValue, forKey: key.rawValue) 
            return defaultValue 
        }
    }
    static func writeBool(key: Keys, value: Bool) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    // = = = = = = = = = = =
    // Int type get/write
    // = = = = = = = = = = =
    static func getInt(key: Keys, _ defaultValue: Int) -> Int {
        if UserDefaults.standard.object(forKey: key.rawValue) != nil {
            return UserDefaults.standard.integer(forKey: key.rawValue)
        } else { 
            UserDefaults.standard.set(defaultValue, forKey: key.rawValue) 
            return defaultValue 
        }
    }
    static func writeInt(key: Keys, value: Int) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    // = = = = = = = = = = =
    // Float type get/write
    // = = = = = = = = = = =
    static func getFloat(key: Keys, _ defaultValue: Float) -> Float {
        if UserDefaults.standard.object(forKey: key.rawValue) != nil {
            return UserDefaults.standard.float(forKey: key.rawValue)
        } else { 
            UserDefaults.standard.set(defaultValue, forKey: key.rawValue) 
            return defaultValue 
        }
    }
    static func writeFloat(key: Keys, value: Float) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    // = = = = = = = = = = =
    // JSON (complex) type get/write
    // = = = = = = = = = = =
    static func getJSON<T: Codable>(key: Keys, _ defaultValue: T) -> T {
        do {
            let jsonDecoder = JSONDecoder()
            let jsonObject: String? = UserDefaults.standard.string(forKey: key.rawValue)
            if jsonObject != nil { 
                let decodedResult = try jsonDecoder.decode(T.self, from: jsonObject!.data(using: .utf8)!)
                return decodedResult
            } else { return defaultValue }
        }
        catch { return defaultValue }
    }
    static func writeJSON<T: Codable>(key: Keys, _ value: T) -> Bool {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonObject = String(data: try jsonEncoder.encode(value), encoding: String.Encoding.utf8)
            UserDefaults.standard.set(jsonObject, forKey: key.rawValue)
            return true
        }
        catch { return false }
    }
}
