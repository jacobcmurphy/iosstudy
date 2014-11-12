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
import CoreData
import CoreLocation

class LoginController: UIViewController {
    
    var locationManager = CLLocationManager()

    
    @IBOutlet weak var activityMon: UIActivityIndicatorView!
    @IBOutlet weak var emailVar: UITextField!
    @IBOutlet weak var passVar: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var githubLogin: UIButton!

    var user = User()
    
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        } else {
           return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityMon.hidden = true;
        locationManager.requestAlwaysAuthorization()

        let firstViewController = FirstViewController.alloc()
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
            if(fetchResults.isEmpty){
                loginButton.addTarget(self, action: Selector("loginClick"), forControlEvents: .TouchUpInside)
                githubLogin.addTarget(self, action: Selector("doOAuthGithub"), forControlEvents: .TouchUpInside)
            } else {
                let firstViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as UIViewController
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendLogin(sender: AnyObject) {
    }
    

    func loginClick() {
//        
        loginButton.hidden = true;
          activityMon.hidden = false;
          activityMon.hidesWhenStopped = true
         // activityMon.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
          view.addSubview(activityMon)
          activityMon.startAnimating()
          let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserEn", inManagedObjectContext: self.managedObjectContext!) as UserEn
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("tabViewController") as UITabBarController;
        let oauthswift = OAuth1Swift(
            consumerKey:    Twitter["consumerKey"]!,
            consumerSecret: Twitter["consumerSecret"]!,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        
        oauthswift.authorizeWithCallbackURL( NSURL(string: "wgo://oauth-callback/twitter")!, success: {
            credential, response in
            self.presentViewController(vc, animated: false, completion: nil);

            println("Twitter", message: "auth_token:\(credential.oauth_token)\n\noauth_toke_secret:\(credential.oauth_token_secret)\n")
            var request = HTTPTask()
            request.responseSerializer = JSONResponseSerializer()
            request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
            request.POST("/twitterauth", parameters: ["twittertoken": "\(credential.oauth_token)" ], success: {(response: HTTPResponse) -> Void in
                let data = response.responseObject as NSDictionary
                newItem.id = data.valueForKey("_id") as String
                newItem.first_name = data.valueForKey("first_name") as String
                newItem.last_name = data.valueForKey("last_name") as String
                self.user.loc = data.valueForKey("loc") as Array<Double>
                newItem.long = self.user.loc[0]
                newItem.lat = self.user.loc[1]
                },failure: {(error: NSError) -> Void in
            })

            var parameters =  Dictionary<String, AnyObject>()
        
            }, failure: {(error:NSError!) -> Void in
                println("Failed to login")
                println(error.localizedDescription)
        })
        

    }
    
    func doOAuthGithub(){
        
        loginButton.hidden = true;
        activityMon.hidden = false;
        activityMon.hidesWhenStopped = true
        // activityMon.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityMon)
        activityMon.startAnimating()
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserEn", inManagedObjectContext: self.managedObjectContext!) as UserEn
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("firstViewController") as UIViewController;
        
        let oauthswift = OAuth2Swift(
            consumerKey:    Github["consumerKey"]!,
            consumerSecret: Github["consumerSecret"]!,
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "code"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "wgo://oauth-callback/github")!, scope: "user,repo", state: "GITHUB", success: {
            credential, response in
            self.presentViewController(vc, animated: false, completion: nil);
            println("Github", message: "oauth_token:\(credential.oauth_token)")
            var request = HTTPTask()
            request.responseSerializer = JSONResponseSerializer()
            request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
            request.POST("/twitterauth", parameters: ["twittertoken": "\(credential.oauth_token)" ], success: {(response: HTTPResponse) -> Void in
                let data = response.responseObject as NSDictionary
                newItem.id = data.valueForKey("_id") as String
                newItem.first_name = data.valueForKey("first_name") as String
                newItem.last_name = data.valueForKey("last_name") as String
                self.user.loc = data.valueForKey("loc") as Array<Double>
                newItem.long = self.user.loc[0]
                newItem.lat = self.user.loc[1]
                },failure: {(error: NSError) -> Void in
            })

            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
        
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
