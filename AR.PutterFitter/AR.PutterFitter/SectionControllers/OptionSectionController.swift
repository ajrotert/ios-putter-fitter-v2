//
//  OptionSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

protocol OptionSectionControllerDelegate {
    func optionSelected(selectedOption: String)
}

class OptionSectionController: ListSectionController {
    var object: OptionDiffable?
    var delegate: OptionSectionControllerDelegate?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? OptionDiffable else {
        return
      }
        self.object = object
    }
    
    public init(delegate: OptionSectionControllerDelegate?) {
        self.delegate = delegate
    }
    
    override func numberOfItems() -> Int {
      return 1
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
      
        let cell = collectionContext?.dequeueReusableCell(of: OptionCell.self, withReuseIdentifier: OptionCell.identifier, for: self, at: index)
        
        guard let cell = cell as? OptionCell else {
            return cell!
        }
        
        weak var wself = self
        
        cell.update(text: object?.option, icon: object?.icon ?? "") {
            if let sself = wself {
                sself.delegate?.optionSelected(selectedOption: self.object?.option ?? "")
            }
        }
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = ((collectionContext?.containerSize.width ?? 0)-20) / 2
      return CGSize(width: width, height: 200)
    }
}

class OptionDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    public var option: String
    public var icon: String
    init(option: String, icon: String) {
        self.option = option
        self.icon = icon
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? OptionDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
