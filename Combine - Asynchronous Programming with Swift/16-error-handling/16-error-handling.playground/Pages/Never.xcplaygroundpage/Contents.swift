import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()
//: ## Never
example(of: "Never sink") {
    Just("Hello")
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

enum MyError: Error {
    case ohNo
}

example(of: "setFailureType") {
    Just("Hello")
        .setFailureType(to: MyError.self)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(.ohNo):
                print("Finished with Oh No!")
            case .finished:
                print("Finished successfully!")
            }
        }, receiveValue: { value in
            print("Got value: \(value)")
        }
    )
        .store(in: &subscriptions)
}

example(of: "assign") {
    class Person {
        let id = UUID()
        var name = "Unknown"
    }
    
    let person = Person()
    print("1", person.name)
    
    Just("Shai")
        //        .setFailureType(to: Error.self)
        .handleEvents(receiveCompletion: { _ in print("2", person.name) })
        .assign(to: \.name, on: person)
        .store(in: &subscriptions)
}

example(of: "assertNoFailure") {
    Just("Hello")
        .setFailureType(to: MyError.self)
//        .tryMap({ _ in throw MyError.ohNo })
        .assertNoFailure()
        .sink(receiveValue: { print("Got value: \($0)") })
        .store(in: &subscriptions)
}


//: [Next](@next)
