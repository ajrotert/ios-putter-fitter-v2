//
//  OptionCell.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import UIKit
import SnapKit

class OptionCell: UICollectionViewCell {
    
    public static let identifier = "OptionCell"
    
    private var labelText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryColor
        label.textAlignment = .center
        label.font = FontHelper.blackFont(size: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var icon: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.05
        return imageView
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.backgroundColor
        view.layer.shadowColor = UIColor.primaryColor.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 8
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
        self.wrapperView.addSubview(self.icon)
        self.icon.snp.makeConstraints{ make in
            make.edges.equalTo(self.wrapperView)
        }
        
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
    
    public func update(text: String?, icon: String, cellTappedBlock: (() -> ())?){
        self.labelText.text = text
        self.icon.image = UIImage(named: icon)
        self.cellTappedBlock = cellTappedBlock
    }
}
