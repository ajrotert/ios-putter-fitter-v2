//
//  LoadingSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

class LoadingSectionController: ListSectionController {
    var object: LoadingDiffable?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? LoadingDiffable else {
        return
      }
        self.object = object
    }
      
    override func numberOfItems() -> Int {
      return 1
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
      
        let cell = collectionContext?.dequeueReusableCell(of: LoadingCell.self, withReuseIdentifier: LoadingCell.identifier, for: self, at: index)
        
        guard let cell = cell as? LoadingCell else {
            return cell!
        }
                
        cell.update()
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = (collectionContext?.containerSize.width ?? 0) - 20
        return CGSize(width: width, height: 100)
    }
}

class LoadingDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    init() {
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? LoadingDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
