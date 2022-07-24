//
//  BannerAdCell.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import Foundation
import UIKit
import SnapKit
import GoogleMobileAds

class BannerAdCell : UICollectionViewCell {
    public static let identifier = "BannerAdCell"
    
    private static let BANNER_ID = "ca-app-pub-3940256099942544/2934735716" // TEST
    
    private var bannerView: GADBannerView?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setupBannerAdViewCell(rootViewController: UIViewController, width: CGFloat) {
        if bannerView == nil {
            bannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(width))
            bannerView?.adUnitID = BannerAdCell.BANNER_ID
            bannerView?.rootViewController = rootViewController
            bannerView?.delegate = self
            bannerView?.load(GADRequest())
        }
    }
}

extension BannerAdCell : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        if let bannerView = self.bannerView {
            self.contentView.addSubview(bannerView)
            bannerView.center = self.contentView.convert(self.contentView.center, to: self.contentView.superview)
        }
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(error)
    }
}
