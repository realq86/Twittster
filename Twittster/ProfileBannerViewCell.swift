//
//  ProfileBannerViewCell.swift
//  Twittster
//
//  Created by Developer on 11/5/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

let kBlurMaskLevel = CGFloat(0.25)
let kNumberOfPages = 2

class ProfileBannerViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var blurMask: UIView!
    @IBOutlet weak var pageTwo: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContentView: UIView!
    
    
    @IBOutlet weak var profileImageViewContainer: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileBannerImageView: UIImageView!
    @IBOutlet weak var profileDescription: UILabel!
    
    
    var user:TwittsterUser! {
        
        didSet {
            if let profileBannerURL = user.profileBackgroundImageHTTPS {
                self.profileBannerImageView.setImageWith(profileBannerURL)
            }
            
            if let profileDescription = user.profileDescription {
                self.profileDescription.text = profileDescription
            }
            
            if let profileImageURL = user.profileImageURLHTTPS {
                self.profileImageView.setImageWith(profileImageURL)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.blurMask.alpha = 0.0
//        
        self.profileImageView.layer.cornerRadius = 10.0
        
        self.profileImageViewContainer.layer.cornerRadius = 10.0
        self.profileImageViewContainer.layer.shadowColor = UIColor.black.cgColor
        self.profileImageViewContainer.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.profileImageViewContainer.layer.shadowRadius = 2.0
        self.profileImageViewContainer.layer.shadowOpacity = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pageControlDidPage(_ sender: Any) {
        let xOffset = scrollView.bounds.width * CGFloat(pageControl.currentPage)
        
        scrollView.setContentOffset(CGPoint(x: xOffset, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offSetPercentIntoSecondPage = scrollView.contentOffset.x / scrollView.bounds.width
            
            self.blurMask.alpha = CGFloat(offSetPercentIntoSecondPage * kBlurMaskLevel)
        
    }
    
    
}
