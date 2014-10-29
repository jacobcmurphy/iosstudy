//
//  SecondViewController.swift
//  wgo
//
//  Created by David Giliotti on 9/4/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Darwin
import SwiftHTTP

class SecondViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    var filteredNames: NSArray = []
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var newWordField: UITextField?
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    var locationManager = CLLocationManager()
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
        super.viewDidLoad()
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /* func wordEntered(alert: UIAlertAction!){
        // store the new word
        self.textView2.text = deletedString + " " + self.newWordField.text
    }*/

    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Add Friend Here"
        self.newWordField = textField
        
        var request = HTTPTask()
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
        request.POST("/users/\(currId)/friends", parameters: ["friends": textField], success: {(response: HTTPResponse) -> Void in
            println("Response\(response.responseObject)")
            },failure: {(error: NSError) -> Void in
        })
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    /*
    func addFriend(){
        let alert = UIAlertController(title: "Add A Friend", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField)
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
       
        
    }*/

   
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        var currId:String = ""
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
            currId = fetchResults[0].id
        }
        var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/\(currId)/friends"))
        return markersDictionary.count
    }
    
    func getDistanceFromLatLonInMi(lat1:Double,lon1:Double,lat2:Double,lon2:Double) -> String{
        var R:Double = 6371 // Radius of the earth km
        var dLat = deg2rad(lat2-lat1)  // deg2rad below
        var dLon = deg2rad(lon2-lon1)
        var a = sin(dLat/2) * sin(dLat/2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon/2) * sin(dLon/2)
        var c = 2 * atan2(sqrt(a), sqrt(1-a))
        var d = R * c; // Distance km
        var dInMi = d*0.621371; // American units
//        if (dInMi < 0.1) {
//            return "<0.1 mi"
//        } else {
//            return roundToTwo(dInMi) + " mi"
//        }
        return (dInMi < 0.1 ? "<0.1 mi" : roundToTwo(dInMi) + " mi");
    }
        
    func deg2rad(deg:Double) -> Double {
        return deg * (M_PI/180)
    }
    
    func roundToTwo(num:Double) -> String {
        return NSString(format:"%8.2f", num)
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as CLLocation
        var currentLat:CLLocationDegrees = location.coordinate.latitude
        var currentLng:CLLocationDegrees = location.coordinate.longitude
        currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        
        var currLng:NSNumber = 0
        var currLat:NSNumber = 0
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
            currId  = fetchResults[0].id
        }
        markersDictionary = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/\(currId)/friends"))
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        //if ( indexPath.row % 2 == 0 ){
        //    cell.backgroundColor = UIColor.blueColor()
        //}
        var firstname: String = markersDictionary[indexPath.row]["first_name"] as String
        var lastname: String = markersDictionary[indexPath.row]["last_name"] as String
        
        var lnglat:NSArray = markersDictionary[indexPath.row]["loc"] as NSArray
        var lng:Double = lnglat[0] as Double
        var lat:Double = lnglat[1] as Double
        let location = locationManager.location
        var currentLat:CLLocationDegrees = location.coordinate.latitude
        var currentLng:CLLocationDegrees = location.coordinate.longitude
        var dist = getDistanceFromLatLonInMi(lat, lon1: lng, lat2: currentLat, lon2: currentLng)
        var name:String = (firstname + " " + lastname + "   " + dist)
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            name = "Test"
        }
        
        
        
        cell.textLabel.text = name
        cell.detailTextLabel?.numberOfLines = 3
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        // cell.detailTextLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("description") as NSString
        
     
        
        return cell
            
        
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) ->[AnyObject]! {
       
        var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
        tableView.editing = false
        
        println("deleteAction")
        }
        
        return [deleteAction]
        }
        
        func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        }
    

    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
      //  self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
       // self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
}

