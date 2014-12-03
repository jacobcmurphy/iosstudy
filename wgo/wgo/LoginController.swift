//
//  LoginController.swift
//  wgo
//
//  Created by David Giliotti on 9/30/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import Foundation
import SwiftHTTP
import CoreLocation

class LoginController: UIViewController, FBLoginViewDelegate {
    
    var locationManager = CLLocationManager()
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    let userId = "userId"
    
    
    @IBOutlet weak var activityMon: UIActivityIndicatorView!
    @IBOutlet var fbLoginView : FBLoginView!
    
    var user = User()
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        
        let firstViewController = FirstViewController.alloc()

        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]

        
    }

    @IBAction func sendLogin(sender: AnyObject) {
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("tabViewController") as UITabBarController;
        self.presentViewController(vc, animated: false, completion: nil);
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
