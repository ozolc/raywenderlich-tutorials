import UIKit

var str = "Chapter 9 Builder Pattern"

// MARK: - Product
// 1
public struct Hamburger {
    public let meat: Meat
    public let sauce: Sauces
    public let toppings: Toppings
}

extension Hamburger: CustomStringConvertible {
    public var description: String {
        return meat.rawValue + " burger"
    }
}

// 2
public enum Meat: String {
    case beef
    case chicken
    case kitten
    case tofu
}

// 3
public struct Sauces: OptionSet {
    public static let mayonnaise = Sauces(rawValue: 1 << 0)
    public static let mustard = Sauces(rawValue: 1 << 1)
    public static let ketchup = Sauces(rawValue: 1 << 2)
    public static let secret = Sauces(rawValue: 1 << 3)
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// 4
public struct Toppings: OptionSet {
    public static let cheese = Toppings(rawValue: 1 << 0)
    public static let lettuce = Toppings(rawValue: 1 << 1)
    public static let pickles = Toppings(rawValue: 1 << 2)
    public static let tomatoes = Toppings(rawValue: 1 << 3)
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Builder
public class HamburgerBuilder {
    
    public enum Error: Swift.Error {
        case soldOut
    }
    
    // 1
    public private(set) var meat: Meat = .beef
    public private(set) var sauces: Sauces = []
    public private(set) var toppings: Toppings = []
    private var soldOutMeats: [Meat] = [.kitten]
    
    // 2
    public func addSauces(_ sauce: Sauces) {
        sauces.insert(sauce)
    }
    
    public func removeSauces(_ sauce: Sauces) {
        sauces.remove(sauce)
    }
    
    public func addToppings(_ topping: Toppings) {
        toppings.insert(topping)
    }
    
    public func removeToppings(_ topping: Toppings) {
        toppings.insert(topping)
    }
    
    public func setMeat(_ meat: Meat) throws {
        guard isAvailable(meat) else { throw Error.soldOut }
        self.meat = meat
    }
    
    public func isAvailable(_ meat: Meat) -> Bool {
        return !soldOutMeats.contains(meat)
    }
    
    // 3
    public func build() -> Hamburger {
        return Hamburger(meat: meat,
                         sauce: sauces,
                         toppings: toppings)
    }
}

// MARK: - Director
public class Employee {
    
    public func createCombo1() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.beef)
        builder.addSauces(.secret)
        builder.addToppings([.lettuce, .tomatoes, .pickles])
        return builder.build()
    }
    
    public func createKittenSpecial() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.kitten)
        builder.addSauces(.mustard)
        builder.addToppings([.lettuce, .tomatoes])
        return builder.build()
    }
}

// MARK: - Example
let burgerFlipper = Employee()

if let combo1 = try? burgerFlipper.createCombo1() {
    print("Nom nom " + combo1.description)
}

if let kittenBurger = try? burgerFlipper.createKittenSpecial() {
    print("Nom nom " + kittenBurger.description)
} else {
    print("Sorry, no kitten burgers here... :[")
}
