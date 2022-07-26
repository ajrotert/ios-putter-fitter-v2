//
//  ButtonCell.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import UIKit
import SnapKit

class ButtonCell: UICollectionViewCell {
    
    public static let identifier = "ButtonCell"
    
    private var labelText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryColor
        label.textAlignment = .center
        label.font = FontHelper.blackFont(size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.backgroundColor
        view.layer.shadowColor = UIColor.primaryColor.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 8
        view.layer.cornerRadius = 20
        return view
    }()
    
    private var cellTappedBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.wrapperView.addSubview(self.labelText)
        self.labelText.snp.makeConstraints{ make in
            make.edges.equalTo(self.wrapperView)
        }
        
        self.contentView.addSubview(self.wrapperView)
        self.wrapperView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(10)
        }
        
        self.wrapperView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    @objc private func cellTapped() {
        cellTappedBlock?()
    }
    
    public func update(buttonText: String?, cellTappedBlock: (() -> ())?) {
        self.labelText.text = buttonText
        self.cellTappedBlock = cellTappedBlock
    }
}
