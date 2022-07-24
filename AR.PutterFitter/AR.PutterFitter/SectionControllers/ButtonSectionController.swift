//
//  ButtonSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

protocol ButtonSectionControllerDelegate {
    func buttonSelected(buttonText: String)
}

class ButtonSectionController: ListSectionController {
    var object: ButtonDiffable?
    var delegate: ButtonSectionControllerDelegate?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? ButtonDiffable else {
        return
      }
        self.object = object
    }
    
    public init(delegate: ButtonSectionControllerDelegate?) {
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
        
        cell.update(buttonText: self.object?.buttonText) {
            if let sself = wself {
                sself.delegate?.buttonSelected(buttonText: sself.object?.buttonText ?? "")
            }
        }
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = (collectionContext?.containerSize.width ?? 0)-20
      return CGSize(width: width, height: 60)
    }
}

class ButtonDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    public var buttonText: String?
    init(buttonText: String?) {
        self.buttonText = buttonText
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? ButtonDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
