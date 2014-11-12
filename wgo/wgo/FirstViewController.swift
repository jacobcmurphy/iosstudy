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
import CoreData

class FirstViewController: UIViewController, CLLocationManagerDelegate , UITableViewDelegate{
    

    
   

    @IBOutlet weak var minimizeButton: UIBarButtonItem!
 
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var myPin:[MKPointAnnotation] = []
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    var locationManager = CLLocationManager()
    var screenHeight:CGFloat = 0;
   
    @IBOutlet var tapRec: UITapGestureRecognizer!
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
        
        screenHeight = mapView.frame.size.height
        
      

        super.viewDidLoad()

        if (CLLocationManager.locationServicesEnabled())
        {
          
            let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "update")
            self.navigationItem.leftBarButtonItem = button
            let homeImage = UIImage(named: "Home")
            let button1 = UIBarButtonItem(image: homeImage, style: .Plain, target: self, action: "goToCurrentLocation")
            self.navigationItem.rightBarButtonItem = button1
            
            tapRec.addTarget(self, action: "tappedView")
            mapView.addGestureRecognizer(tapRec)
            mapView.userInteractionEnabled = true
            /*Starts thread to call update() every 10 seconds)*/
            let priority = DISPATCH_QUEUE_PRIORITY_HIGH
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            dispatch_async(dispatch_get_main_queue(), {
            var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("update"), userInfo: nil, repeats: true)//Update is called every 10 seconds
           println("hello from UI thread executed as dispatch")
            
            })
            })
           println("hello from UI thread")
            let location = locationManager.location
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    /*Function called when map needs to be maximized*/
    func tappedView(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        tableView.hidden = true
        let miniImage = UIImage(named: "Minimize")
        let button1 = UIBarButtonItem(image: miniImage, style: .Plain, target: self, action: "miniClick")
        self.navigationItem.rightBarButtonItem = button1
       UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = screenHeight
            self.mapView.frame = frame
            }, completion: nil)
    }
    /*Function called when map needs to be minimized*/
    func miniClick(){
        
        let homeImage = UIImage(named: "Home")
        tableView.hidden = false
        
        let button1 = UIBarButtonItem(image: homeImage, style: .Plain, target: self, action: "goToCurrentLocation")
        self.navigationItem.rightBarButtonItem = button1
       
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = self.screenHeight
            self.mapView.frame = frame
            }, completion: nil)

    }
    /*Not Being Used At The Moment, But Will Be..Used for to show CoreData info*/
    func presentItemInfo() {
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
                let alert = UIAlertView()
                alert.title = fetchResults[0].first_name
                alert.message = fetchResults[0].last_name
                alert.show()
            
        }
    }
    
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
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
            var currId:String = fetchResults[0].id
        var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/\(currId)/friends"))
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //saddInitialPin(locationManager)
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
            
            myPin.append(MKPointAnnotation())
            
            myPin[i].coordinate = currLoc
            myPin[i].title = (firstname + " " + lastname)
            self.mapView.addAnnotation(myPin[i])
          //  mapView(mapView,viewForAnnotation: myPin[i])
            /* End Of Pin Code*/
        }
        }
    }
    
    func refresh(){
        
        update()
       
        
        
    }
    
    /**USED TO LATER CHANGE THE MARKER IMAGE**/
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MKPointAnnotation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.image = UIImage(named:"Marker2")
            anView.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        
        return anView
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