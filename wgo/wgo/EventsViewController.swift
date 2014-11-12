//
//  EventsViewController.swift
//  wgo
//
//  Created by David Giliotti on 11/3/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CoreLocation



class EventsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, NSXMLParserDelegate{
    
    
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var tableView: UITableView!
    var currId:String = ""
    var markersDictionary: NSArray = []
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
    
    let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addEvent")
    self.navigationItem.rightBarButtonItem = button
    
    super.viewDidLoad()
    
    
    }
    
    
    func addEvent(){
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddEventView") as AddEventView
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }

    
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        if(indexPath.row==0){
            cell.textLabel.text = "Brandeis Calendar"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }/*else{
            var title:String = ""
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            let location = locationManager.location
            var currLat:CLLocationDegrees = location.coordinate.latitude
            var currLng:CLLocationDegrees = location.coordinate.longitude
            markersDictionary = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/events/loc/\(currLng)/\(currLat)"))
            var test:NSArray = markersDictionary[indexPath.row-1] as NSArray
            var test1:AnyObject = test[0]
            title = test1["title"] as String
        }
        
       cell.textLabel.text = title
        */
        return cell
    }
    

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        if(indexPath.row == 0){
            let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CalenderController") as CalenderController
            self.navigationController?.pushViewController(secondViewController, animated: true)
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