//
//  ResultsCell.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import UIKit
import SnapKit

class ResultsCell: UICollectionViewCell {
    
    public static let identifier = "ResultsCell"
    
    private var manufacturerText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryColor
        label.textAlignment = .left
        label.font = FontHelper.mediumFont(size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private var modelText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryColor
        label.textAlignment = .left
        label.font = FontHelper.mediumFont(size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        return view
    }()
    
    private var putterImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var forwardImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Forward")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .primaryColor
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
        self.contentView.addSubview(self.wrapperView)
        self.wrapperView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(10)
        }
        
        self.wrapperView.addSubview(self.putterImage)
        self.putterImage.snp.makeConstraints{ make in
            make.top.equalTo(self.wrapperView.snp.top)
            make.left.equalTo(self.wrapperView.snp.left)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        self.wrapperView.addSubview(self.forwardImage)
        self.forwardImage.snp.makeConstraints{ make in
            make.centerY.equalTo(self.wrapperView.snp.centerY)
            make.right.equalTo(self.wrapperView.snp.right).inset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        self.wrapperView.addSubview(self.dividerView)
        self.dividerView.snp.makeConstraints{ make in
            make.top.equalTo(self.wrapperView.snp.top)
            make.bottom.equalTo(self.wrapperView.snp.bottom)
            make.left.equalTo(self.putterImage.snp.right)
            make.width.equalTo(2)
        }
        
        self.wrapperView.addSubview(self.manufacturerText)
        self.manufacturerText.snp.makeConstraints{ make in
            make.bottom.equalTo(self.wrapperView.snp.centerY)
            make.left.equalTo(self.dividerView.snp.right).offset(10)
            make.right.equalTo(self.wrapperView.snp.right)
        }

        self.wrapperView.addSubview(self.modelText)
        self.modelText.snp.makeConstraints{ make in
            make.top.equalTo(self.wrapperView.snp.centerY)
            make.left.equalTo(self.dividerView.snp.right).offset(10)
            make.right.equalTo(self.wrapperView.snp.right)
        }
        
        self.wrapperView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    @objc private func cellTapped() {
        cellTappedBlock?()
    }
    
    public func update(manufacturerText: String?, modelText: String?, putterImage: UIImage?, cellTappedBlock: (() -> ())?){
        self.manufacturerText.text = manufacturerText
        self.modelText.text = modelText
        self.putterImage.image = putterImage
        self.cellTappedBlock = cellTappedBlock
    }
}
