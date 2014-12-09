//
//  ViewController.swift
//  PopDatePickerApp
//
//  Created by Valerio Ferrucci on 07/10/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

import UIKit
import MapKit
import SwiftHTTP


class AddEventViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var startPopDatePicker : PopDatePicker?
    var endPopDatePicker : PopDatePicker?
    
    
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    var currId = ""
    var myPin:CustomPointAnnotation = CustomPointAnnotation()
    
    override func viewDidLoad() {
        
        mapView.hidden = true
        mapView.delegate = self
        showMap()
        createEventButton.addTarget(self, action: Selector("postInfo"), forControlEvents: .TouchUpInside)
        super.viewDidLoad()
        
        startPopDatePicker = PopDatePicker(forTextField: startTextField)
        endPopDatePicker = PopDatePicker(forTextField: endTextField)
        startTextField.delegate = self
        endTextField.delegate = self
        
        let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        if (dictionary?.valueForKey("appId") != nil) {
            self.currId = dictionary?.valueForKey("appId") as String!
            println("currId in firstView: " + currId)
        }

        
        var locationManager = CLLocationManager()
        let location = locationManager.location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func resign() {
        
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
    func showMap(){
       
        mapView.hidden = false
        
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let location = locationManager.location
        var currLat:CLLocationDegrees = location.coordinate.latitude
        var currLng:CLLocationDegrees = location.coordinate.longitude
        let currLoc = CLLocationCoordinate2DMake(currLat, currLng)
        //let eventImage = UIImage(named: "EventMarker")
        myPin.imageName = "EventMarker"
        myPin.coordinate = currLoc
        myPin.title = "Drag Me"
        self.mapView.addAnnotation(myPin)
        
    }
    
    
    func postInfo(){
        let lng = myPin.coordinate.longitude
        let lat = myPin.coordinate.latitude
        var request = HTTPTask()
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
        request.PUT("events/user/\(self.currId)/", parameters: ["title": "\(titleTextField.text)", "description" : "\(descriptionTextField.text)", "start_time" : "\(startTextField.text)", "end_time" : "\(endTextField.text)", "loc" : "[\(lng), \(lat)]"], success: {(response: HTTPResponse) -> Void in
            println("Response\(response.responseObject)")
            },failure: {(error: NSError) -> Void in
        })
        
        
    }
    
    
   /* func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        //        println("test")
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
        //        println(anView.image)
        return anView
    }
    
    */
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .Purple
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            let eventImage = UIImage(named: "EventMarker")
            pinAnnotationView.image = eventImage
            println(pinAnnotationView.draggable)
            return pinAnnotationView
        }
        
        return nil
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    
    if (textField === startTextField) {
        resign()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let initDate = formatter.dateFromString(startTextField.text)
        
        startPopDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField : UITextField) -> () in
            
            // here we don't use self (no retain cycle)
            forTextField.text = newDate.ToDateMediumString()
            
        })
        return false
    }
    if (textField === endTextField) {
        resign()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let initDate = formatter.dateFromString(endTextField.text)
        endPopDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField : UITextField) -> () in
            
            // here we don't use self (no retain cycle)
            forTextField.text = newDate.ToDateMediumString()
        })
        return false
    }
  
        return true
    
}
    
    @IBAction func save(sender: AnyObject) {
        
        var msg : String
        if (startTextField.text != "") {
            msg = titleTextField.text + " " + startTextField.text
        } else {
            msg = "Date empty!"
        }
        let alert:UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:.Alert)
        alert.addAction(UIAlertAction(title: "Event Added!", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        self.presentViewController(alert, animated:true, completion:nil);
        
    }
}

