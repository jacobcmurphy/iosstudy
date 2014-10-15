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

class LoginController: UIViewController {
    
    var user = User()

    
    
    @IBOutlet weak var emailVar: UITextField!
    @IBOutlet weak var passVar: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
      
            return managedObjectContext
            
        }
        else {
           
            return nil
        }
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("here")
        loginButton.addTarget(self, action: Selector("loginClick"), forControlEvents: .TouchUpInside)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendLogin(sender: AnyObject) {
 
        }
    
    func loginClick(){
        println("0")
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("UserEn", inManagedObjectContext: self.managedObjectContext!) as UserEn
        println("1")
        var request = HTTPTask()
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "54.69.226.38"
        println("2")
        request.POST("/login", parameters: ["email": emailVar.text, "password": passVar.text], success: {(response: HTTPResponse) -> Void in
            let data = response.responseObject as NSDictionary
            println("3")
           self.user.id = data.valueForKey("_id") as String
            newItem.id = data.valueForKey("_id") as String
            self.user.first_name = data.valueForKey("first_name") as String
            newItem.first_name = data.valueForKey("first_name") as String
            self.user.last_name = data.valueForKey("last_name") as String
            newItem.last_name = data.valueForKey("last_name") as String
            println("4")
            self.user.loc = data.valueForKey("loc") as Array<Double>
            newItem.long = self.user.loc[0]
            newItem.lat = self.user.loc[1]
            println("5")
            
            },failure: {(error: NSError) -> Void in
                
                
        })

        println("UserID: \(user.id)")
        sleep(1)
        println("UserID: \(user.id)")
        println("First Name: \(user.first_name)")
        println("Last Name: \(user.last_name)")
        println("Location: \(user.loc)")


        
      //  var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "login"))
    //    println(markersDictionary)
        //       var currUser = User(id: <#String#>, first_name: <#String#>, last_name: <#String#>, loc: <#Array<Double>#>)
        
    }
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
