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

class LoginController: UIViewController, CLLocationManagerDelegate, FBLoginViewDelegate {
    
    var locationManager = CLLocationManager()
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    var currId = ""
    
    
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

    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        
        Locksmith.saveData(["wgoAuth" : FBSession.activeSession().accessTokenData.accessToken], forKey: self.key, inService: self.service, forUserAccount: self.userAccount)
        println("Facebook auth token: \(FBSession.activeSession().accessTokenData.accessToken) -- Also saved token to Keychain")
        
        
        
        
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
//        println("User: \(user)")
//        println("User ID: \(user.objectID)")
        let fbUserId = user.name as String
//        println("User Name: \(user.name)")
        let fullName = user.name as String
        var userEmail = user.objectForKey("email") as String
//        println("User Email: \(userEmail)")
        let fullNameArr = fullName.componentsSeparatedByString(" ")
        var firstName: String = fullNameArr[0]
        var lastName: String = fullNameArr[1]
//        println(firstName)
//        println(lastName)
        
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        var lat:CLLocationDegrees = location.coordinate.latitude
        var lng:CLLocationDegrees = location.coordinate.longitude
        
        
        var request = HTTPTask()
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
        request.POST("/auth", parameters: ["token": "\(FBSession.activeSession().accessTokenData.accessToken)", "email" : "\(userEmail)", "last_name" : "\(lastName)", "first_name" : "\(firstName)", "auth_id" : "\(fbUserId)", "loc" : "[\(lng), \(lat)]"], success: {(response: HTTPResponse) -> Void in
            let data = response.responseObject as NSDictionary
            println("DATA FROM AUTH: \(data)")
            
            let appUserId = data.valueForKey("_id") as String
            println("appUserId from Server: " + appUserId)
            
            let deleteRequest = LocksmithRequest(service: self.service, userAccount: self.userAccount, key: self.key, requestType: .Delete)
            Locksmith.performRequest(deleteRequest)
            
            let saveRequest = LocksmithRequest(service: self.service, userAccount: self.userAccount, key: self.key, data: ["token": "\(FBSession.activeSession().accessTokenData.accessToken)", "appId" : "\(appUserId)", "email" : "\(userEmail)", "first_name" : "\(firstName)", "last_name" : "\(lastName)"])
            Locksmith.performRequest(saveRequest)
            
            println("Should have saved userId to Locksmith")
            
            let readRequest = LocksmithRequest(service: self.service, userAccount: self.userAccount, key: self.key)
            let (dictionary, error) = Locksmith.performRequest(readRequest)

//            println("THE DICTIONARY:  \(dictionary!)")

            self.currId =  dictionary?.valueForKey("appId") as String!
            println("Should have loaded userId from Locksmith")
            println("currId is: " + self.currId)
            if (self.currId != "") {
                println("Reached here")
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewControllerWithIdentifier("tabViewController") as UITabBarController;
                self.presentViewController(vc, animated: false, completion: nil);
            }
            },failure: {(error: NSError) -> Void in
        })

        
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
