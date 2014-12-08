//
//  EventsViewController.swift
//  wgo
//
//  Created by David Giliotti on 11/3/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftHTTP



class EventsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, NSXMLParserDelegate{
    
    
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var tableView: UITableView!
    var currId:String = ""
    var eventsArray:NSArray = []
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    
    
    override func viewDidLoad() {
    
    let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addEvent")
    self.navigationItem.rightBarButtonItem = button
    let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
    let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
    if (dictionary?.valueForKey("appId") != nil) {
        self.currId = dictionary?.valueForKey("appId") as String!
        println("currId in eventView: " + currId)
    }
        
        
    super.viewDidLoad()
    
        
    
    }
    
    
    func addEvent(){
        
        let addEventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddEventViewController") as AddEventViewController

            self.navigationController?.pushViewController(addEventViewController, animated: true)
        
    }

    
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        var currLat:CLLocationDegrees = location.coordinate.latitude
        var currLng:CLLocationDegrees = location.coordinate.longitude
        var eventsArray:NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/events/loc/\(currLng)/\(currLat)"))
        return eventsArray.count+1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let calenderImage = UIImage(named: "Events")
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        if(indexPath.row==0){
            cell.imageView?.image = calenderImage
            cell.textLabel?.text = "Brandeis Calendar"
            cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        }else{
            
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            let location = locationManager.location
            var currLat:CLLocationDegrees = location.coordinate.latitude
            var currLng:CLLocationDegrees = location.coordinate.longitude
            eventsArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/events/loc/\(currLng)/\(currLat)"))
            if(eventsArray.count > 0){
                var eventDictionary:NSDictionary = eventsArray[indexPath.row-1]["obj"] as NSDictionary
                cell.textLabel?.text =  eventDictionary["title"] as? String
            }
        }
        
       
        
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
            
            var eventDictionary:NSDictionary = self.eventsArray[indexPath.row-1]["obj"] as NSDictionary
            var id:String = eventDictionary["_id"] as String
            println("ID: " + id)
            var request = HTTPTask()
            request.responseSerializer = JSONResponseSerializer()
            request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
            request.POST("events/pin/\(self.currId)/\(id)", parameters: nil, success: {(response: HTTPResponse) -> Void in
                println("Response\(response.responseObject)")
                },failure: {(error: NSError) -> Void in
            })
         //   println(eventDictionary["title"] + "is pinned")

            
         
        }
        let myRedColor = UIColor(red:0xcc/255, green:0x66/255,blue:0x00/255,alpha:1.0)
        pinAction.backgroundColor = UIColor.orangeColor()
        
        return [pinAction]
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    





}