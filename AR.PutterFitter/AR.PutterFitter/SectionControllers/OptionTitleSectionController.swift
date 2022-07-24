//
//  OptionTitleSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

class OptionTitleSectionController: ListSectionController {
    var object: OptionTitleDiffable?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? OptionTitleDiffable else {
        return
      }
        self.object = object
    }
      
    override func numberOfItems() -> Int {
      return 1
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
      
        let cell = collectionContext?.dequeueReusableCell(of: OptionTitleCell.self, withReuseIdentifier: OptionTitleCell.identifier, for: self, at: index)
        
        guard let cell = cell as? OptionTitleCell else {
            return cell!
        }
                
        cell.update(title: self.object?.title)
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = (collectionContext?.containerSize.width ?? 0) - 20
        return CGSize(width: width, height: (self.object?.title.heightWithConstrainedWidth(width: width, font: FontHelper.regularFont(size: 26)) ?? 40) + 20)
    }
}

class OptionTitleDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    public var title: String
    init(title: String) {
        self.title = title
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? OptionTitleDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
