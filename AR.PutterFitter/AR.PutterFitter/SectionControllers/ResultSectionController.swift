//
//  ResultSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

protocol ResultSectionControllerDelegate {
    func resultSelected()
}

class ResultSectionController: ListSectionController {
    var object: ResultsDiffable?
    var delegate: ResultSectionControllerDelegate?
    
    override func didUpdate(to object: Any) {
      guard let object = object as? ResultsDiffable else {
        return
      }
        self.object = object
    }
    
    public init(delegate: ResultSectionControllerDelegate?) {
        self.delegate = delegate
    }
    
    override func numberOfItems() -> Int {
      return 1
    }
    override func cellForItem(at index: Int) -> UICollectionViewCell {
      
        let cell = collectionContext?.dequeueReusableCell(of: ResultsCell.self, withReuseIdentifier: ResultsCell.identifier, for: self, at: index)
        
        guard let cell = cell as? ResultsCell else {
            return cell!
        }
        
        weak var wself = self
        
        cell.update(manufacturerText: self.object?.manufacturerText, modelText: self.object?.modelText, putterImage: self.object?.putterImage, cellTappedBlock: {
            
            if let sself = wself {
                sself.delegate?.resultSelected()
            }
        })
        
        return cell

    }
    override func sizeForItem(at index: Int) -> CGSize {
      let width = (collectionContext?.containerSize.width ?? 0)-20
      return CGSize(width: width, height: 120)
    }
}

class ResultsDiffable: ListDiffable {
    private var identifier: String = UUID().uuidString

    public var manufacturerText: String
    public var modelText: String
    public var putterImage: UIImage
    init(manufacturerText: String, modelText: String, putterImage: UIImage) {
        self.manufacturerText = manufacturerText
        self.modelText = modelText
        self.putterImage = putterImage
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: self.identifier)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
      guard let object = object as? ResultsDiffable else {
         return false
      }
        return self.identifier == object.identifier
    }
}
