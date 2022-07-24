//
//  FontHelper.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import UIKit

class FontHelper {
    static func regularFont(size: Float) -> UIFont {
        return UIFont(name: "Kanit-Regular", size: CGFloat(size))!
    }
    
    static func mediumFont(size: Float) -> UIFont {
        return UIFont(name: "Kanit-Medium", size: CGFloat(size))!
    }
    
    static func blackFont(size: Float) -> UIFont {
        return UIFont(name: "Kanit-Black", size: CGFloat(size))!
    }
}
