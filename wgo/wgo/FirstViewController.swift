//
//  FirstViewController.swift
//  wgo
//
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import SwiftHTTP


class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class FirstViewController: UIViewController, CLLocationManagerDelegate , UITableViewDelegate, MKMapViewDelegate {

    @IBOutlet weak var minimizeButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var myPin:[CustomPointAnnotation] = []
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    var locationManager = CLLocationManager()
    var screenHeight:CGFloat = 0;
    let service = "WGO"
    let userAccount = "WGOUser"
    var mapBottomBound:CGFloat = 0;
    let key = "wgoAuth"
    var currId = ""
    let button1 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    let button2 = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    @IBOutlet var tapRec: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {

        mapView.delegate = self
        screenHeight = mapView.frame.size.height
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()


        let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        if (dictionary?.valueForKey("appId") != nil) {
            self.currId = dictionary?.valueForKey("appId") as String!
            println("currId in firstView: " + currId)
        }
        
        
        
        if (CLLocationManager.locationServicesEnabled()) {
            
            /*Refresh Button*/
            let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "update")
            self.navigationItem.leftBarButtonItem = button
            /*Go To Current Location Button*/
            let homeImage = UIImage(named: "Home")
            button1.setImage(homeImage, forState: UIControlState.Normal)
            mapBottomBound = mapView.frame.size.height
            button1.frame = CGRectMake(10, mapBottomBound - 40, 30, 30)
            button1.addTarget(self, action: "goToCurrentLocation", forControlEvents: UIControlEvents.TouchUpInside)
            /*Minimize Button*/
            let miniImage = UIImage(named: "Minimize")
            button2.setImage(miniImage, forState: UIControlState.Normal)
            button2.addTarget(self, action: "miniClick", forControlEvents: UIControlEvents.TouchUpInside)
           // button2.backgroundColor = UIColor.whiteColor()
            mapView.addSubview(button1)
            mapView.addSubview(button2)
            button2.hidden = true
            /*Settings Button*/
            let settingsImage = UIImage(named: "Settings")
            let settingsButton = UIBarButtonItem(image: settingsImage, style: .Plain, target: self, action: "settingsHit")
            self.navigationItem.rightBarButtonItem = settingsButton
            /*Maximize Map On Tap*/
            tapRec.addTarget(self, action: "tappedView")
            mapView.addGestureRecognizer(tapRec)
            mapView.userInteractionEnabled = true
            /*Starts thread to call update() every 10 seconds)*/
            let priority = DISPATCH_QUEUE_PRIORITY_HIGH
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            dispatch_async(dispatch_get_main_queue(), {
            var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("update"), userInfo: nil, repeats: true)//Update is called every 10 seconds
//           println("hello from UI thread executed as dispatch")
            
            })
            })
//           println("hello from UI thread")
            let location = locationManager.location
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            self.mapView.setRegion(region, animated: true)
        }
        
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        println("test")
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }
        else {
            anView.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
       
        let cpa = annotation as CustomPointAnnotation
      
        anView.image = UIImage(named: cpa.imageName)
        println(anView.image)
        return anView
    }
    
    /*Function called when map needs to be maximized*/
    func tappedView(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        tableView.hidden = true
        button2.hidden = false
       UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = screenHeight
            self.mapView.frame = frame
            self.mapBottomBound = frame.size.height
            self.button1.frame = CGRectMake(10, self.mapBottomBound - 165, 30, 30)
            self.button2.frame = CGRectMake(330, self.mapBottomBound - 165, 30, 30)
            }, completion: nil)
    }
    /*Function called when map needs to be minimized*/
    func miniClick(){
        
        let homeImage = UIImage(named: "Home")
        let settingsImage = UIImage(named: "Settings")
        tableView.hidden = false
        let button1 = UIBarButtonItem(image: settingsImage, style: .Plain, target: self, action: "settingsHit")
        self.navigationItem.rightBarButtonItem = button1
       button2.hidden = true
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = self.screenHeight
            self.mapView.frame = frame
            self.mapBottomBound = frame.size.height
            self.button1.frame = CGRectMake(10, self.mapBottomBound - 40, 30, 30)
            }, completion: nil)

    }
    
    func settingsHit(){
        let settingsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsController") as SettingsController
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    /*Not Being Used At The Moment, But Will Be..Used for to show CoreData info*/
    /*Called When "Go Home" Button is hit*/
    func goToCurrentLocation(){
        let location = locationManager.location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.mapView.setRegion(region, animated: true)
    }
    
    /*Update is called every 10 seconds,
     * It clears the pins and gets stuff from the database
     * It then loops through all of the people and makes a pin for each one
     */
    func update(){
        self.mapView.removeAnnotations(myPin)
        myPin = []
        let (userDictionary, userError) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        /*if (userDictionary?.valueForKey(userId) != nil) {
            self.currId = userDictionary?.valueForKey(userId) as String
            println("currId in update: " + currId)
        }*/
        var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/friends/\(self.currId)"))
          /* Start Loop to Update ALL Markers */
        for i in 0...markersDictionary.count-1 {
            var lnglat:NSArray = markersDictionary[i]["loc"] as NSArray
            var firstname: String = markersDictionary[i]["first_name"] as String
            var lastname: String = markersDictionary[i]["last_name"] as String
            var subname:String = "subname"
            var lng:double_t = lnglat[0] as double_t
            var lat:double_t = lnglat[1] as double_t
            /*Making a Pin here...*/
            var currentLat:CLLocationDegrees = lat
            var currentLng:CLLocationDegrees = lng
            currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
            myPin.append(CustomPointAnnotation())
            myPin[i].imageName = "Marker2"
            myPin[i].coordinate = currLoc
            myPin[i].title = (firstname + " " + lastname)
            self.mapView.addAnnotation(myPin[i])
          //  mapView(mapView,viewForAnnotation: myPin[i])
            /* End Of Pin Code*/
        }
    }
    
    func refresh(){
//        update()
    }
   
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as CLLocation
        var currentLat:CLLocationDegrees = location.coordinate.latitude
        var currentLng:CLLocationDegrees = location.coordinate.longitude
        currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel.text = "Event #\(indexPath.row)"
        cell.detailTextLabel?.text = "Event Description"
        return cell
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) ->[AnyObject]! {
        
        var pinAction = UITableViewRowAction(style: .Default, title: "Unpin") { (action, indexPath) -> Void in
            tableView.editing = false
            
            
        }
        let myRedColor = UIColor(red:0xcc/255, green:0x66/255,blue:0x00/255,alpha:1.0)
        pinAction.backgroundColor = UIColor.redColor()
        
        return [pinAction]
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
}