//
//  LabelCell.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import UIKit
import SnapKit

class LabelCell: UICollectionViewCell {
    
    public static let identifier = "LabelCell"
    
    private var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .primaryColor
        label.font = FontHelper.regularFont(size: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.contentView.addSubview(self.label)
        self.label.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }
    
    public func update(text: String?){
        self.label.text = text
    }
}
