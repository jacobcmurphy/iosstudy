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
            } else {
                let firstViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as UIViewController
            }
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendLogin(sender: AnyObject) {
    }
    
    func loginClick(){
        loginButton.hidden = true;
        activityMon.hidden = false;
        activityMon.hidesWhenStopped = true
        activityMon.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityMon)
        activityMon.startAnimating()
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserEn", inManagedObjectContext: self.managedObjectContext!) as UserEn
        var request = HTTPTask()
        request.auth = HTTPAuth(username: emailVar.text, password: passVar.text)
        request.auth?.persistence = .Permanent
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
        request.GET("/login/\(emailVar.text)/\(passVar.text)", parameters: nil, success: {(response: HTTPResponse) -> Void in
            let data = response.responseObject as NSDictionary
            newItem.id = data.valueForKey("_id") as String
            newItem.first_name = data.valueForKey("first_name") as String
            newItem.last_name = data.valueForKey("last_name") as String
            self.user.loc = data.valueForKey("loc") as Array<Double>
            newItem.long = self.user.loc[0]
            newItem.lat = self.user.loc[1]
            },failure: {(error: NSError) -> Void in
        })
        
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
