//
//  FittingHeap.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/24/22.
//

import Foundation

class FittingHeap {
    private var heap = [PutterCharacteristics]()
    
    public func insert(data: PutterCharacteristics) {
        heap.append(data)
        heap = heap.sorted(by: { $0.importance > $1.importance })
    }
    
    public func delete() -> PutterCharacteristics? {
        if heap.count > 0 {
            let data = heap.removeFirst()
            heap = heap.sorted(by: { $0.importance > $1.importance })
            return data
        }
        return nil
    }
    
    public func count() -> Int {
        return heap.count
    }
}
