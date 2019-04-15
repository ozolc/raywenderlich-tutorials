public protocol Copying: class {
    // 1
    init(_ prototype: Self)
}

extension Copying {
    // 2
    public func copy() -> Self {
        return type(of: self).init(self)
    }
}

// 1
public class Monster: Copying {
    
    public var health: Int
    public var level: Int
    
    public init(health: Int, level: Int) {
        self.health = health
        self.level = level
    }
    
    // 2
    public required convenience init(_ monster: Monster) {
        self.init(health: monster.health, level: monster.level)
    }
}

// 1
public class EyeballMonster: Monster {
    
    public var redness = 0
    
    // 2
    public init(health: Int, level: Int, redness: Int) {
        self.redness = redness
        super.init(health: health, level: level)
    }
    
    // 3
    @available(*, unavailable, message: "Call copy() instead")
    public required convenience init(_ prototype: Monster) {
        let eyeballMonster = prototype as! EyeballMonster
        self.init(health: eyeballMonster.health,
                  level: eyeballMonster.level,
                  redness: eyeballMonster.redness)
    }
}

let monster = Monster(health: 700, level: 37)
let monster2 = monster.copy()
print("Watch out!! That monster's level is \(monster2.level)!")

let eyeball = EyeballMonster(health: 3002, level: 60, redness: 999)
let eyeball2 = eyeball.copy()
print("Eww! Its eyeball redness is \(eyeball2.redness)!")

let eyeballMonster3 = EyeballMonster(monster)
