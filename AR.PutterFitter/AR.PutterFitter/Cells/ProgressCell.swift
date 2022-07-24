//
//  ProgressCell.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import UIKit
import SnapKit

class ProgressCell: UICollectionViewCell {
    
    public static let identifier = "ProgressCell"
    
    private var progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.trackTintColor = .lightGray
        bar.progressTintColor = .primaryColor
        bar.layer.cornerRadius = 4
        bar.clipsToBounds = true
        bar.transform = CGAffineTransformMakeScale(1, 4)
        return bar
    }()
    
    private var progressText: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Progress: "
        label.textColor = .primaryColor
        label.font = FontHelper.regularFont(size: 14)
        label.textAlignment = .left
        return label
    }()
    
    private var progressCountText: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .primaryColor
        label.font = FontHelper.regularFont(size: 14)
        label.textAlignment = .right
        return label
    }()
    
    private var wrapperView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
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
            make.left.equalTo(self.contentView.snp.left)
            make.right.equalTo(self.contentView.snp.right)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        self.wrapperView.addSubview(self.progressText)
        self.progressText.snp.makeConstraints { make in
            make.top.equalTo(self.wrapperView.snp.top)
            make.left.equalTo(self.wrapperView.snp.left)
            make.right.equalTo(self.wrapperView.snp.right)
        }
        
        self.wrapperView.addSubview(self.progressCountText)
        self.progressCountText.snp.makeConstraints { make in
            make.top.equalTo(self.wrapperView.snp.top)
            make.left.equalTo(self.wrapperView.snp.left)
            make.right.equalTo(self.wrapperView.snp.right)
        }
        
        self.wrapperView.addSubview(self.progressBar)
        self.progressBar.snp.makeConstraints { make in
            make.top.equalTo(self.progressText.snp.bottom).offset(10)
            make.left.equalTo(self.wrapperView.snp.left)
            make.right.equalTo(self.wrapperView.snp.right)
            make.bottom.equalTo(self.wrapperView.snp.bottom)
        }
    }
    
    public func update(progress: Float, count: String){
        self.progressBar.progress = progress
        self.progressCountText.text = count
    }
}
