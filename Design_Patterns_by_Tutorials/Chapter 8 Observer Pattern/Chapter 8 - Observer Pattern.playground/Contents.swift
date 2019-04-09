import Foundation

var str = "Chapter 8 - Observer Pattern (KVO)"

// MARK: - KVO
// 1
@objcMembers public class KVOUser: NSObject {
    // 2
    dynamic var name: String
    
    // 3
    public init(name: String) {
        self.name = name
    }
}

// 1
print("-- KVO Example --")

// 2
let kvoUser = KVOUser(name: "Ray")

// 3
var kvoObserver: NSKeyValueObservation? = kvoUser.observe(\.name, options: [.initial, .new]) {
    (user, change) in
    
    print("User's name is \(user.name)")
}

kvoUser.name = "Rockin' Ray"

kvoObserver = nil
kvoUser.name = "Ray has left the building"

