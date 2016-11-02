//
//  AppDelegate.swift
//  Twittster
//
//  Created by Developer on 10/27/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var sharedTwitterDateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss '+0000' yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter
    }()
    
    static var sharedLocalDateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yyy  h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: NSTimeZone.local.secondsFromGMT())
        return formatter
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        if TwittsterUser.currentUser != nil {
//            print("Current User Found")
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let naviVC = storyboard.instantiateViewController(withIdentifier: "MainNavigationControllerID") as! UINavigationController
//            window?.rootViewController = naviVC
//        }
//        else {
//            print("Current User Not Found")
//        }
//        
//        weak var weakSelf = self
//        let notificationName = Notification.Name(kUserLogoutNotificationName)
//        NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: OperationQueue.main) { (notification:Notification) in
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateInitialViewController()
//            weakSelf?.window?.rootViewController = vc
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("AppDeletate OpenURL: \(url.description)")
        
    
        TwitterServer.sharedInstance.processOpenURL(url: url)
        
        return true
    }

}

