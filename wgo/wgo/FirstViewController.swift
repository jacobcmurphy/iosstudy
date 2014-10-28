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

class FirstViewController: UIViewController, CLLocationManagerDelegate , UITableViewDelegate, NSXMLParserDelegate{
    
    /**RSS**/
    var parser = NSXMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var fdescription = NSMutableString()


    @IBOutlet var mapView: MKMapView!
    var myPin:[MKPointAnnotation] = []
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    var locationManager = CLLocationManager()
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
        
        /**RSS**/
        feeds = []
        var url: NSURL = NSURL(string: "http://25livepub.collegenet.com/calendars/campus.rss")!
        parser = NSXMLParser (contentsOfURL: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()

        super.viewDidLoad()

        if (CLLocationManager.locationServicesEnabled())
        {
            
            tapRec.addTarget(self, action: "tappedView")
            minimizeButton.addTarget(self, action: Selector("miniClick"), forControlEvents: .TouchUpInside)
            mapView.addGestureRecognizer(tapRec)
            mapView.userInteractionEnabled = true
            minimizeButton.hidden = true
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
        let screenHeight = screenSize.height;
        minimizeButton.hidden = false
       UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = screenHeight
            self.mapView.frame = frame
            }, completion: nil)
    }
    /*Function called when map needs to be minimized*/
    func miniClick(){
         minimizeButton.hidden = true
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut  , animations: {
            var frame = self.mapView.frame
            frame.size.height = 213
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
            /* End Of Pin Code*/
        }
        }
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
    
    
    //**RSS**//
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        element = elementName
        
        if (element as NSString).isEqualToString("item") {
            elements = NSMutableDictionary.alloc()
            elements = [:]
            ftitle = NSMutableString.alloc ()
            ftitle = ""
            link = NSMutableString.alloc()
            link = ""
            fdescription = NSMutableString.alloc()
            fdescription = ""
        }
        
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if (elementName as NSString).isEqualToString("item") {
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title")
            }
            
            if (link != "") {
                elements.setObject(link, forKey: "link")
            }
            
            if (fdescription != "") {
                elements.setObject(fdescription, forKey: "description")
            }
            feeds.addObject(elements)
        }
        
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        
        if element.isEqualToString("title"){
            ftitle.appendString(string)
            
        }else if element.isEqualToString("link"){
            link.appendString(string)
            
        }else if element.isEqualToString("description"){
            fdescription.appendString(string)
            
        }
        
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel.text = feeds.objectAtIndex(indexPath.row).objectForKey ("title") as NSString
        let myRedColor = UIColor(red:0xfa/255, green:0xeb/255,blue:0xeb/255,alpha:1.0)
        cell.backgroundColor = myRedColor
        cell.detailTextLabel?.numberOfLines = 3
       // cell.detailTextLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("description") as NSString
        
        return cell
    }
    
    func cleanUp(description:String) -> String{
        
        var description = description.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString("&nbsp", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString(";", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString("&ndash", withString: "-", options: NSStringCompareOptions.LiteralSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString("&quot", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString("&#39", withString: "\'", options: NSStringCompareOptions.LiteralSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString("&gt", withString: ">", options: NSStringCompareOptions.LiteralSearch, range: nil)
        description = description.stringByReplacingOccurrencesOfString("&amp", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)

    return description
    }
    
 
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var description = feeds.objectAtIndex(indexPath.row).objectForKey("description") as String
        description = cleanUp(description)
        let title = feeds.objectAtIndex(indexPath.row).objectForKey ("title") as NSString
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        //println("You selected cell #\(indexPath.row)!")
    }
    
}