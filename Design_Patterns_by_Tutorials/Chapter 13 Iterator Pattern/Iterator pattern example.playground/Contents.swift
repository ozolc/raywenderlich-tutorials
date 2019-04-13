import Foundation

// 1
public struct Queue<T> {
    private var array: [T?] = []
    
    // 2
    private var head = 0
    
    // 3
    public var isEmpty: Bool {
        return count == 0
    }
    
    // 4
    public var count: Int {
        return array.count - head
    }
    
    // 5
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    // 6
    public mutating func dequeue() -> T? {
        guard head < array.count,
            let element = array[head] else {
                return nil
        }
        
        array[head] = nil
        head += 1
        let percentage = Double(head) / Double(array.count)
        if array.count > 50,
            percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
}

extension Queue: Sequence {
    public func makeIterator() -> IndexingIterator<ArraySlice<T?>> {
        let nonEmptyValues = array[head ..< array.count]
        return nonEmptyValues.makeIterator()
    }
}

public struct Ticket {
    var description: String
    var priority: PriorityType
    
    enum PriorityType {
        case low
        case medium
        case high
    }
    
    init(description: String, priority: PriorityType) {
        self.description = description
        self.priority = priority
    }
}

extension Ticket {
    var sortIndex: Int {
        switch self.priority {
        case .low: return 0
        case .medium: return 1
        case .high: return 2
        }
    }
}

var queue = Queue<Ticket>()
queue.enqueue(Ticket(description: "Wireframe Tinder for dogs app", priority: .low))
queue.enqueue(Ticket(description: "Set up 4k monitor for Josh", priority: .medium))
queue.enqueue(Ticket(description: "There is smoke coming out of my laptop",
                     priority: .high))
queue.enqueue(Ticket(description: "Put googly eyes on the Roomba",
                     priority: .low))
queue.dequeue()

print("List of Tickets in queue:")
for ticket in queue {
    print(ticket?.description ?? "No Description")
}

let sortedTickets = queue.sorted { $0!.sortIndex > ($1?.sortIndex)! }
var sortedQueue = Queue<Ticket>()

for ticket in sortedTickets {
    sortedQueue.enqueue(ticket!)
}

print("\n")
print("Tickets sorted by priority:")
for ticket in sortedQueue {
    print(ticket?.description ?? "No Description")
}
