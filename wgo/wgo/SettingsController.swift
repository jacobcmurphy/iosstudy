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
      
        logOutButton.addTarget(self, action: Selector("logOutClick"), forControlEvents: .TouchUpInside)
        var screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //logOutButton.frame.width = screenWidth as CGFloat
        super.viewDidLoad()
        
    }
    
    func logOutClick(){
        
        let deleteRequest = LocksmithRequest(service: self.service, userAccount: self.userAccount, key: self.key, requestType: .Delete)
        Locksmith.performRequest(deleteRequest)
        var theFBSession = FBSession.activeSession()
        var check = FBSession.closeAndClearTokenInformation(theFBSession)
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        println("User Email: \(userEmail)")
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    
}