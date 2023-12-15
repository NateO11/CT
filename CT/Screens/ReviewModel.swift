///
///
/// Dont worrt bout this
///
///







import Foundation

// Struct representing a review enum
struct Review {
    var votes: Int
    var user: String
    var review: String
    var subject: String 
}

// Generic struct representing a Max Priority Queue
struct MaxPriorityQueue<T> {
    private var heap: [T]             // The underlying array representing the binary heap
    private let comparator: (T, T) -> Bool  // The comparator function to determine priority

    // Initialize the Max Priority Queue with a comparator function
    init(comparator: @escaping (T, T) -> Bool) {
        self.heap = []
        self.comparator = comparator
    }

    // Enqueue an element into the priority queue
    mutating func enqueue(_ element: T) {
        heap.append(element)
        heapifyUp()
    }

    // Dequeue the element with the highest priority from the priority queue
    mutating func dequeue() -> T? {
        if heap.isEmpty { return nil }
        if heap.count == 1 { return heap.removeFirst() }

        heap.swapAt(0, heap.count - 1)
        let removedElement = heap.removeLast()
        heapifyDown()

        return removedElement
    }

    // Restore the heap property by moving the newly added element up
    private mutating func heapifyUp() {
        var currentIndex = heap.count - 1

        while currentIndex > 0 {
            let parentIndex = (currentIndex - 1) / 2

            if comparator(heap[currentIndex], heap[parentIndex]) {
                heap.swapAt(currentIndex, parentIndex)
                currentIndex = parentIndex
            } else {
                break
            }
        }
    }

    // Restore the heap property by moving the root element down
    private mutating func heapifyDown() {
        var currentIndex = 0

        while true {
            let leftChildIndex = 2 * currentIndex + 1
            let rightChildIndex = 2 * currentIndex + 2
            
           
            var maxIndex = currentIndex

            if leftChildIndex < heap.count && comparator(heap[leftChildIndex], heap[maxIndex]) {
                maxIndex = leftChildIndex
            }

            if rightChildIndex < heap.count && comparator(heap[rightChildIndex], heap[maxIndex]) {
                maxIndex = rightChildIndex
            }

            if maxIndex == currentIndex {
                break
            }

            heap.swapAt(currentIndex, maxIndex)
            currentIndex = maxIndex
        }
    }
}


