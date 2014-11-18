//
//  initialNavController.swift
//  wgo
//
//  Created by Sharat Sridhar on 11/17/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import Foundation
import UIKit

class InitialNavController: UINavigationController {
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "WGOAuth"

    
    override func viewDidLoad() {
        println("Reached ViewDidLoad")
        let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        
        if (dictionary?.count != 0) {
            println("Printing dictionary from ViewDidLoad:")
            println(dictionary?.valueForKey(key))
            let vc = storyboard.instantiateViewControllerWithIdentifier("tabViewController") as UITabBarController;
            self.presentViewController(vc, animated: false, completion: nil);
        } else {
            let vc = storyboard.instantiateViewControllerWithIdentifier("loginController") as UITabBarController;
            self.presentViewController(vc, animated: false, completion: nil);
        }
        
    }

}