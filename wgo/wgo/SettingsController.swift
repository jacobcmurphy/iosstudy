//
//  SettingsController.swift
//  wgo
//
//  Created by Sharat Sridhar on 11/17/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class SettingsController: UIViewController, FBLoginViewDelegate {
    
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet var fbLoginView : FBLoginView!
    

    override func viewDidLoad() {
        
        self.title = "Settings"
        logOutButton.addTarget(self, action: Selector("logOutClick"), forControlEvents: .TouchUpInside)
        var screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //logOutButton.frame.width = screenWidth as CGFloat
        super.viewDidLoad()
        
    }
    
    func logOutClick(){
        FBSession.activeSession().closeAndClearTokenInformation()
        let deleteRequest = LocksmithRequest(service: self.service, userAccount: self.userAccount, key: self.key, requestType: .Delete)
        Locksmith.performRequest(deleteRequest)
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("SplashViewController") as SplashViewController;
        self.presentViewController(vc, animated: false, completion: nil);
        
    }
    
     
}