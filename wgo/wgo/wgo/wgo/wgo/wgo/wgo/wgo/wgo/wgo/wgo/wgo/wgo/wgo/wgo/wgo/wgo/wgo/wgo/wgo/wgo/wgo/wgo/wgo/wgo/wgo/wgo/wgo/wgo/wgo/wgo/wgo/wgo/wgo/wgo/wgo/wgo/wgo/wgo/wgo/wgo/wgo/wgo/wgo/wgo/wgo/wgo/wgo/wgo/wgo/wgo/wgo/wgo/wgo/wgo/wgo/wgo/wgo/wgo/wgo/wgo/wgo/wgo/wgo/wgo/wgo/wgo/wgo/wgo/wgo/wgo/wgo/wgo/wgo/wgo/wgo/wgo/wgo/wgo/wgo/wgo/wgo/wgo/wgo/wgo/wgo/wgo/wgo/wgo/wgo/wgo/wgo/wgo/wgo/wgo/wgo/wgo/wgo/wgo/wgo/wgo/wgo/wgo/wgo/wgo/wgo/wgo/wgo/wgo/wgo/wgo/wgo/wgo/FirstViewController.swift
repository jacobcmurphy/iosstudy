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
    
    @IBOutlet var mapView: MKMapView!
    var myPin = MKPointAnnotation()
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    var locationManager = CLLocationManager()
   // var mapHeight:Double = mapView.frame.size.height
    @IBOutlet weak var minimizeButton: UIButton!

    
        let tapRec = UITapGestureRecognizer()
    


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
        
        if (CLLocationManager.locationServicesEnabled())
        {
            
            tapRec.addTarget(self, action: "tappedView")
            minimizeButton.addTarget(self, action: Selector("miniClick"), forControlEvents: .TouchUpInside)
            mapView.addGestureRecognizer(tapRec)
            mapView.userInteractionEnabled = true
            minimizeButton.hidden = true
            
            let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            
            println("gcd hello")
            dispatch_async(dispatch_get_main_queue(), {
            var timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("update"), userInfo: nil, repeats: true)//Update is called every 30 seconds
           println("hello from UI thread executed as dispatch")
            
            })
            })
           println("hello from UI thread")
            println("hi")
           // presentItemInfo()
        }
        
    }
    
    
    func tappedView(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height;
        minimizeButton.hidden = false
       UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = screenHeight
            self.mapView.frame = frame
            }, completion: nil)
    }
    
    func miniClick(){
         minimizeButton.hidden = true
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = 213
            self.mapView.frame = frame
            }, completion: nil)

    }

    func presentItemInfo() {
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
            
            let alert = UIAlertView()
            alert.title = fetchResults[0].first_name
            alert.message = fetchResults[0].last_name
            alert.show()
        }
    }
    
    func update(){
        
        var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "users"))
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        addInitialPin(locationManager)
        var myPin:[MKPointAnnotation] = []
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
            self.mapView.addAnnotation(myPin[i])
            myPin[i].coordinate = currLoc
            myPin[i].title = (firstname + " " + lastname)
            /* End Of Pin Code*/
        }
    }
   
    func addInitialPin(location: CLLocationManager!){
        /* Making a Pin here...*/
        var name = "Name"
        let location = locationManager.location
        var currentLat:CLLocationDegrees = location.coordinate.latitude
        var currentLng:CLLocationDegrees = location.coordinate.longitude
        currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
        var myPin = MKPointAnnotation()
        self.mapView.addAnnotation(myPin)
        myPin.coordinate = currLoc
        myPin.title = name
        /* Makes The Initial Center Start Up at Pin */
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.mapView.setRegion(region, animated: true)
        /* End Of Pin Code*/
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
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")!
        cell.textLabel?.text = "Event #\(indexPath.row)"
        cell.detailTextLabel?.text = "Event Description"
        return cell
    }
    
}