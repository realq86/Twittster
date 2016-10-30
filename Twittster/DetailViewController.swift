//
//  DetailViewController.swift
//  Twittster
//
//  Created by Developer on 10/29/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var retweetPanel: UIView!
    
    @IBOutlet weak var profilePanel: UIView!
    
    
    @IBOutlet weak var tweetStatPanel: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
//        let scrollViewBounds = scrollView.bounds
////        let containerViewBounds = contentView.bounds
//        
//        var scrollViewInsets = UIEdgeInsets.zero
//        scrollViewInsets.top = scrollViewBounds.size.height/2.0;
//        scrollViewInsets.top -= contentView.bounds.size.height/2.0;
//        
//        scrollViewInsets.bottom = scrollViewBounds.size.height/2.0
//        scrollViewInsets.bottom -= contentView.bounds.size.height/2.0;
//        scrollViewInsets.bottom += 1
//        
//        scrollView.contentInset = scrollViewInsets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
