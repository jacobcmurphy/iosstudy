//
//  SpashViewController.swift
//  wgo
//
//  Created by Sharat Sridhar on 11/17/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    let userId = "userId"
    
    override func viewDidAppear(animated: Bool) {
        let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        if (dictionary?.valueForKey(key) != nil) {
            println("Printing dictionary from ViewDidAppear:")
            println(dictionary?.valueForKey("wgoAuth"))
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let vc = storyboard.instantiateViewControllerWithIdentifier("tabViewController") as UITabBarController;
            self.presentViewController(vc, animated: false, completion: nil);
        } else {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("loginController") as UIViewController;
            self.presentViewController(vc, animated: false, completion: nil);
        }
    }
}
