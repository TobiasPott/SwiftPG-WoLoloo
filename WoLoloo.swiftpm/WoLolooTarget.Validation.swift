import SwiftUI

extension WoLolooTarget {
    
    var isValid: Bool { 
        get {  
            do {
                let macRegEx = try Regex("^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")
                if mac.ranges(of: macRegEx).count == 0 { return false }
                if mac.isEmpty || addr.isEmpty { return false }
            } catch {
                print("Failed to create regex")
                return false
            }
            return true
        }
    }
    
    var isValidAddr: Bool {
        if addr.isEmpty { return false }
        if addr.count <= 2 { return false }
        return true
    }
    var isValidMac: Bool {
        if mac.isEmpty { return false }
        if mac.count <= 12 { return false }
        return true
    }
    
}
