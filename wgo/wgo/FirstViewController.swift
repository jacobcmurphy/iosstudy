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
        
        var markersDictionary: NSArray = parseJSON(getJSON("http://54.69.174.192/users"))

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

            addInitialPin(locationManager)
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
    
    func put(params : Dictionary<String, String>) {
        //example self.put(["first_name":"FirstName", "last_name":"LastName"]

        var request = NSMutableURLRequest(URL: NSURL(string: "http://54.69.174.192/users"))
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "PUT"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()

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






