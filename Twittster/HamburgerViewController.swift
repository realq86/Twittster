//
//  HamburgerViewController.swift
//  Twittster
//
//  Created by Developer on 11/2/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    var contentVC:UIViewController! {
        didSet {
            if (oldValue != nil) {
                oldValue.willMove(toParentViewController: nil)
                oldValue.view.removeFromSuperview()
                oldValue.removeFromParentViewController()
            }
            self.addChildViewController(contentVC)
            contentVC.willMove(toParentViewController: self)
            contentView.addSubview(contentVC.view)
            contentVC.didMove(toParentViewController: self)
        }
        
    }

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    
    var contentViewPreviousMargin:CGFloat!
    
    var menuVC:MenuViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuVC.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.hamburgerVC = self
        
        self.menuVC = menuVC
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Hamburger ViewWillAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func onEdgePanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            
            if velocity.x > 0 {
                contentViewPreviousMargin = contentViewLeadingConstraint.constant
            }
        }
        else if sender.state == .changed {
            contentViewLeadingConstraint.constant = contentViewPreviousMargin + translation.x
        }
        else if sender.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0.0 { // pan right
                    self.contentViewLeadingConstraint.constant  =  self.view.frame.size.width * 0.9
                    self.contentView.subviews[0].isUserInteractionEnabled = false
                }
                else {  // pan left
                    self.contentViewLeadingConstraint.constant = 0
                    self.contentView.subviews[0].isUserInteractionEnabled = true
                }
                self.view.layoutIfNeeded()
            })
        }
        
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
