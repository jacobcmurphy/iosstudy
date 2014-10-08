//
//  LoginController.swift
//  wgo
//
//  Created by David Giliotti on 9/30/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import Foundation

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
        
        Poster.post(["email": emailVar.text, "password": passVar.text], url: "login");
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
