// Base Mediator class
open class Mediator<CollegueType> {
    
    private class ColleagueWrapper {
        var strongColleague: AnyObject?
        weak var weakColleague: AnyObject?
        
        var colleague: CollegueType? {
            return { self.weakColleague ?? self.strongColleague} as? CollegueType
        }
        
        init(weakColleague: CollegueType) {
            self.strongColleague = nil
            self.weakColleague = weakColleague as AnyObject
        }
        
        init(strongColleague: CollegueType) {
            self.strongColleague = strongColleague as AnyObject
            self.weakColleague = nil
        }
    }
    
    // MARK: - Instance Properties
    private var colleagueWrappers: [ColleagueWrapper] = []
    
    public var colleagues: [CollegueType] {
        var colleagues: [CollegueType] = []
        colleagueWrappers = colleagueWrappers.filter {
            guard let colleague = $0.colleague else { return false }
            colleagues.append(colleague)
            return true
        }
        return colleagues
    }
    
    // MARK: - Object Lifecycle
    public init() { }
    
    // MARK: - Colleague Management
    public func addColleague(_ colleague: CollegueType, strongReference: Bool = true) {
        let wrapper: ColleagueWrapper
        if strongReference {
            wrapper = ColleagueWrapper(strongColleague: colleague)
        } else {
            wrapper = ColleagueWrapper(weakColleague: colleague)
        }
        colleagueWrappers.append(wrapper)
    }
    
    public func removeColleague(_ colleague: CollegueType) {
        guard let index = colleagues.firstIndex(where:  {
            ($0 as AnyObject) === (colleague as AnyObject)
        }) else { return }
        colleagueWrappers.remove(at: index)
    }
    
    public func invokeColleagues(closure: (CollegueType) -> Void) {
        colleagues.forEach(closure)
    }
    
    public func invokeColleagues(by colleague: CollegueType, closuere: (CollegueType) -> Void) {
        colleagues.forEach {
            guard ($0 as AnyObject) !== (colleague as AnyObject) else { return }
            closuere($0)
        }
    }
}

// MARK: - Colleague Protocol
public protocol Colleague: class {
    func colleague(_ colleague: Colleague?, didSendMessage message: String)
}

// MARK: - Mediator Protocol
public protocol MediatorProtocol: class {
    func addColleague(_ colleague: Colleague)
    func sendMessage(_ message: String, by colleague: Colleague)
}

// MARK: - Colleague
public class Musketeer {
    
    public var name: String
    public weak var mediator: MediatorProtocol?
    
    public init(mediator: MediatorProtocol, name: String) {
        self.mediator = mediator
        self.name = name
        mediator.addColleague(self)
    }
    
    public func sendMessage(_ message: String) {
        print("\(name) sent: \(message)")
        mediator?.sendMessage(message, by: self)
    }
}

extension Musketeer: Colleague {
    public func colleague(_ colleague: Colleague?, didSendMessage message: String) {
        print("\(name) received: \(message)")
    }
}

// MARK: - Mediator
public class MusketeerMediator: Mediator<Colleague> {
    
}

extension MusketeerMediator: MediatorProtocol {
    
    public func addColleague(_ colleague: Colleague) {
        self.addColleague(colleague, strongReference: true)
    }
    
    public func sendMessage(_ message: String, by colleague: Colleague) {
        invokeColleagues(by: colleague) {
            $0.colleague(colleague, didSendMessage: message)
        }
    }
}

// MARK: - Example
let mediator = MusketeerMediator()
let athos = Musketeer(mediator: mediator, name: "Athos")
let porthos = Musketeer(mediator: mediator, name: "Porthos")
let aramis = Musketeer(mediator: mediator, name: "Aramis")

athos.sendMessage("One for all...!")
print("")

porthos.sendMessage("and all for one...!")
print("")

aramis.sendMessage("Unus pro omnibus, omnes pro uno!")
print("")

mediator.invokeColleagues() {
    $0.colleague(nil, didSendMessage: "Charge!")
}
