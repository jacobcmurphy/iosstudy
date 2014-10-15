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

class LoginController: UIViewController {
    
    

    
    
    @IBOutlet weak var emailVar: UITextField!
    @IBOutlet weak var passVar: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: Selector("loginClick"), forControlEvents: .TouchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendLogin(sender: AnyObject) {
 
        }
    
    func loginClick(){
        var user = User()
        var request = HTTPTask()
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "http://54.186.68.209"
        request.POST("/login", parameters: ["email": emailVar.text, "password": passVar.text], success: {(response: HTTPResponse) -> Void in
            let data = response.responseObject as NSDictionary
            
            user.id = data.valueForKey("_id") as String
            
            user.first_name = data.valueForKey("first_name") as String
            user.last_name = data.valueForKey("last_name") as String
            user.loc = data.valueForKey("loc") as Array<Double>

            
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
