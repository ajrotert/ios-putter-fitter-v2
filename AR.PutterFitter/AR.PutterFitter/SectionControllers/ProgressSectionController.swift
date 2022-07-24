//
//  ProgressSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

class ProgressSectionController: ListSectionController {
    var object: ProgressDiffable?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? ProgressDiffable else {
        return
      }
        self.object = object
    }
      
    override func numberOfItems() -> Int {
      return 1
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
      
        let cell = collectionContext?.dequeueReusableCell(of: ProgressCell.self, withReuseIdentifier: ProgressCell.identifier, for: self, at: index)
        
        guard let cell = cell as? ProgressCell else {
            return cell!
        }
                
        cell.update(progress: self.object?.progress ?? 0, count: self.object?.count ?? "")
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = (collectionContext?.containerSize.width ?? 0) - 20
      return CGSize(width: width, height: 60)
    }
}

class ProgressDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    public var progress: Float
    public var count: String
    init(progress: Float, count: String) {
        self.progress = progress
        self.count = count
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? ProgressDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
