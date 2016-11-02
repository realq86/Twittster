//
//  HamburgerViewController.swift
//  Twittster
//
//  Created by Developer on 11/2/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var manuView: UIView!
    
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var contentViewPreviousMargin:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onEdgePanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            contentViewPreviousMargin = contentViewLeadingConstraint.constant
        }
        else if sender.state == .changed {
            contentViewLeadingConstraint.constant = contentViewPreviousMargin + translation.x
        }
        else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0.0 { // pan right
                    self.contentViewLeadingConstraint.constant  =  self.view.frame.size.width * 0.9
                }
                else {  // pan left
                    self.contentViewLeadingConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
        
    }
//    @IBAction func onEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
//        
//        let translation = sender.translation(in: view)
//        let velocity = sender.velocity(in: view)
//        
//        if sender.state == .began {
//             contentViewPreviousMargin = contentViewLeadingConstraint.constant
//        }
//        else if sender.state == .changed {
//            contentViewLeadingConstraint.constant = contentViewPreviousMargin + translation.x
//        }
//        else if sender.state == .ended {
//            
//        }
//        
//    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
