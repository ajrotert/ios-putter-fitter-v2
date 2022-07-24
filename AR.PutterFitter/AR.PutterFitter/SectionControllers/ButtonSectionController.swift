//
//  ButtonSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

protocol BackButtonSectionControllerDelegate {
    func backSelected()
}

class BackButtonSectionController: ListSectionController {
    var object: BackDiffable?
    var delegate: BackButtonSectionControllerDelegate?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? BackDiffable else {
        return
      }
        self.object = object
    }
    
    public init(delegate: BackButtonSectionControllerDelegate?) {
        self.delegate = delegate
    }
    
    override func numberOfItems() -> Int {
      return 1
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
      
        let cell = collectionContext?.dequeueReusableCell(of: ButtonCell.self, withReuseIdentifier: ButtonCell.identifier, for: self, at: index)
        
        guard let cell = cell as? ButtonCell else {
            return cell!
        }
        
        weak var wself = self
        
        cell.update() {
            if let sself = wself {
                sself.delegate?.backSelected()
            }
        }
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = (collectionContext?.containerSize.width ?? 0)-20
      return CGSize(width: width, height: 60)
    }
}

class BackDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    init() {
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? BackDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
