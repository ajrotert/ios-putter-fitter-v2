//
//  StringExtensions.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
extension StringProtocol {
    subscript(offset: Int) -> String {
        if(offset < self.count){
            return String(self[index(startIndex, offsetBy: offset)])
        }
        return String()
    }
}
