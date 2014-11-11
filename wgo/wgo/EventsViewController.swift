//
//  EventsViewController.swift
//  wgo
//
//  Created by David Giliotti on 11/3/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import Foundation



class EventsViewController: UIViewController, UITableViewDelegate, NSXMLParserDelegate{
    
    
    
    
    @IBOutlet weak var tableView: UITableView!

 override func viewDidLoad() {
 
    
    super.viewDidLoad()
    
    
    }
    
    
    

    
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel.text = "Brandeis Calender"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        if(indexPath.row == 1){
        let calenderController:CalenderController = CalenderController()
        
        self.presentViewController(calenderController, animated: true, completion: nil)
        }
    }
    

    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) ->[AnyObject]! {
        
        var pinAction = UITableViewRowAction(style: .Default, title: "Pin") { (action, indexPath) -> Void in
            tableView.editing = false
            
         
        }
        let myRedColor = UIColor(red:0xcc/255, green:0x66/255,blue:0x00/255,alpha:1.0)
        pinAction.backgroundColor = UIColor.orangeColor()
        
        return [pinAction]
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    





}