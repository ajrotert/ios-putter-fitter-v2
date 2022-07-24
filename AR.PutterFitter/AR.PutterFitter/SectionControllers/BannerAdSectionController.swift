//
//  BannerAdSectionController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import IGListKit

class BannerAdSectionController: ListSectionController {
  var object: BannerAdDiffable?
    
  override func didUpdate(to object: Any) {
    guard let object = object as? BannerAdDiffable else {
      return
    }
      self.object = object
  }
    
  override func numberOfItems() -> Int {
    return 1
  }
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    
      let cell = collectionContext?.dequeueReusableCell(of: BannerAdCell.self, withReuseIdentifier: BannerAdCell.identifier, for: self, at: index)
      
      guard let cell = cell as? BannerAdCell, let rootViewController = object?.rootViewController else {
          return cell!
      }
      
      let width = (collectionContext?.containerSize.width ?? 0) - 20
      
      cell.setupBannerAdViewCell(rootViewController: rootViewController, width: width)
      
      return cell

  }
  override func sizeForItem(at index: Int) -> CGSize {
    let width = (collectionContext?.containerSize.width ?? 0) - 20
    return CGSize(width: width, height: 80)
  }
}

class BannerAdDiffable {
    private var identifier: String = UUID().uuidString

    public weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}
extension BannerAdDiffable: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return identifier as NSString
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? BannerAdDiffable else {
       return false
    }
    return self.identifier == object.identifier
  }
}
