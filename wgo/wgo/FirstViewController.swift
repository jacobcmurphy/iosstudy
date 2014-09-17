//
//  FirstViewController.swift
//  wgo
//
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate , UITableViewDelegate{
    
      @IBOutlet var mapView: MKMapView!
     var myPin = MKPointAnnotation()
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var locationManager = CLLocationManager()
  //  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapMap:")
//        singleTap.delegate = self
//        singleTap.numberOfTapsRequired = 1
//        singleTap.numberOfTouchesRequired = 1
//        mapView.addGestureRecognizer(singleTap)
        
        // Do any additional setup after loading the view, typically from a nib.
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

            // test pin
            var homeLati:CLLocationDegrees = 42.367545
            var homelong:CLLocationDegrees = -71.258492
            var myHome:CLLocationCoordinate2D = CLLocationCoordinate2DMake(homeLati, homelong)
            var myHomePin = MKPointAnnotation()
            myHomePin.coordinate = myHome
            myHomePin.title = "Home"
            myHomePin.subtitle = "David's Home"
            self.mapView.addAnnotation(myHomePin)
            addInitialPin(locationManager)
            
        
        }
        
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
        myPin.subtitle = "Name's Place"
        /* Makes The Initial Center Start Up at Pin */
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.mapView.setRegion(region, animated: true)
        /* End Of Pin Code
        */
    }
    
    func updatePin(location: CLLocationManager!){
        let location = locationManager.location
        var currentLat:CLLocationDegrees = location.coordinate.latitude
        var currentLng:CLLocationDegrees = location.coordinate.longitude
        currLoc = CLLocationCoordinate2DMake(currentLat, currentLng)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        updatePin(manager)
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
    
}






