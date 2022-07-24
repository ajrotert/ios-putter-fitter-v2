//
//  LabelSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

class LabelSectionController: ListSectionController {
    var object: LabelDiffable?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? LabelDiffable else {
        return
      }
        self.object = object
    }
      
    override func numberOfItems() -> Int {
      return 1
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
      
        let cell = collectionContext?.dequeueReusableCell(of: LabelCell.self, withReuseIdentifier: LabelCell.identifier, for: self, at: index)
        
        guard let cell = cell as? LabelCell else {
            return cell!
        }
                
        cell.update(text: self.object?.text)
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = (collectionContext?.containerSize.width ?? 0) - 20
        return CGSize(width: width, height: (self.object?.text.heightWithConstrainedWidth(width: width, font: FontHelper.regularFont(size: 16)) ?? 40) + 20)
    }
}

class LabelDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    public var text: String
    init(text: String) {
        self.text = text
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? LabelDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
