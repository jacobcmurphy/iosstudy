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

class FirstViewController: UIViewController, CLLocationManagerDelegate , UITableViewDelegate{
    
    @IBOutlet var mapView: MKMapView!
    var myPin = MKPointAnnotation()
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    
    var locationManager = CLLocationManager()
    
  //  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var markersDictionary: NSArray = parseJSON(getJSON("http://54.69.221.141/users"))

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

            addInitialPin(locationManager)
            
            
       /*PIN CODE*//*
            let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in

                println("gcd hello")
                dispatch_async(dispatch_get_main_queue(), {
                        var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
                        println("hello from UI thread executed as dispatch")
                    
                })
            })
            println("hello from UI thread")
            
            */
            
            
            var myPin:[MKPointAnnotation] = []
            
            for i in 0...markersDictionary.count-1 {
                var lnglat:NSArray = markersDictionary[i]["loc"] as NSArray
                //fix this with lengths
                var firstname: String = markersDictionary[i]["first_name"] as String
                var lastname: String = markersDictionary[i]["last_name"] as String
                var subname:String = "subname"
                var lng:double_t = lnglat[0] as double_t
                var lat:double_t = lnglat[1] as double_t
            
                /*Making a Pin here...
                */
                //let location = locationManager.location
              //  println(firstname+ " " + lastname)
                println(lat)
                println(lng)
                var currentLat:CLLocationDegrees = lat
                var currentLng:CLLocationDegrees = lng
                
                currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
                myPin.append(MKPointAnnotation())
                self.mapView.addAnnotation(myPin[i])
                myPin[i].coordinate = currLoc
                myPin[i].title = (firstname + " " + lastname)
                /* End Of Pin Code*/
               // addPin(name, subname, lat, lng)
            }
            
        }
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
         var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    
    }
    
    func update(){
        println("David is Sexy")
    }

   
    func addInitialPin(location: CLLocationManager!){
        /*
        Making a Pin here...
        */
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
        /* End Of Pin Code
      
        */
    }
    
    func addPin(/*location: CLLocationManager!,*/ name: String, subname: String,  lat: double_t, long: double_t){
        /*
        Making a Pin here...
        */
        //let location = locationManager.location
        var currentLat:CLLocationDegrees = lat
        var currentLng:CLLocationDegrees = long
        currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
        var myPin = MKPointAnnotation()
        self.mapView.addAnnotation(myPin)
        myPin.coordinate = currLoc
        myPin.title = name
        myPin.subtitle = subname
        /* End Of Pin Code
        */
    }
    
    /*
    func updatePin(location: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        let location = locations.last as CLLocation
        var currentLat:CLLocationDegrees = location.coordinate.latitude
        var currentLng:CLLocationDegrees = location.coordinate.longitude
        currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
    }
    */
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
        cell.textLabel?.text = "Event #\(indexPath.row)"
        cell.detailTextLabel?.text = "Event Description"
        return cell
    }
    
    /* Parsing Stuff */
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }

    /*
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        //var info:NSArray = boardsDictionary.valueForKey("data") as NSArray
        println(boardsDictionary)
        return boardsDictionary
    }*/
    
    func parseJSON(inputData: NSData) -> NSArray{
        var error: NSError?
        var boardsDictionary: NSArray = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
        var latlng:NSArray = boardsDictionary[3]["loc"] as NSArray
        println(boardsDictionary)
        return boardsDictionary
    }
    
    /* End Of Parsing Stuff*/
    
}






