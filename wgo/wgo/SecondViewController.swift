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

class SecondViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate {
    
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    var locationManager = CLLocationManager()
    
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
        var currId:String = ""
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
        var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/\(currId)/friends"))
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
        cell.textLabel.text = (firstname + " " + lastname + " " + dist)
        cell.detailTextLabel?.numberOfLines = 3
        // cell.detailTextLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("description") as NSString
        
        return cell
            
        
    }


}

