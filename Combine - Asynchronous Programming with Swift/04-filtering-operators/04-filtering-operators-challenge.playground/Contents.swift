import Foundation
import Combine

let numbers = (1...100).publisher

numbers
    .dropFirst(50)
    .prefix(20)
    .filter { $0 % 2 == 0 }
    .sink(receiveValue: { print($0) })


