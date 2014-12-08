//
//  SecondViewController.swift
//  wgo
//
//  Created by David Giliotti on 9/4/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import CoreLocation
import Darwin
import SwiftHTTP

class SecondViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate{
    
    
    var friendId:String = "0";
    var filteredNames: NSArray = []
    //var fbreq:FBRequest = FBRequest.requestForMyFriends()
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    
     var finalId:String = ""
    @IBOutlet weak var tableView: UITableView!
    var searchName:String = " "
    @IBOutlet weak var newWordField: UITextField?
    var currLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var data = NSMutableData()
    var locationManager = CLLocationManager()
    var markersDictionaryCount: NSArray = []
    var currId:String = ""
    var markersDictionary: NSArray = []
    var finalCount:Int = 0
    
    override func viewDidLoad() {
        
        let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
        let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
        if (dictionary?.valueForKey("appId") != nil) {
            self.currId = dictionary?.valueForKey("appId") as String!
            println("currId in secondView: " + currId)
        }
      //  updateCount()
   
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateCount(test: Int){
        self.tableView(tableView, numberOfRowsInSection: test)
    }
    
    func testFB(name: String){
       
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as NSDictionary
            println("Result Dict: \(resultdict)")
            var data : NSArray = resultdict.objectForKey("data") as NSArray
            
            for i in 0...data.count {
                let valueDict : NSDictionary = data[i] as NSDictionary
                var id:String = valueDict.objectForKey("id") as String
                let first_name = valueDict.objectForKey("first_name") as String
                 println("the first name is \(first_name) and the actual name is \(name)")
                if(first_name == name){
                    self.finalId = id
                    println("FOUND")
                    println("the id value for \(first_name) is \(self.finalId)")
                   
                }
              //  println("the id value for \(first_name) is \(id)")
               
            }
            
           
            
            var friends = resultdict.objectForKey("data") as NSArray
            println("Found \(friends.count) friends")
    }
   
    }
    func deleteFriend(id: String){
        var request = HTTPTask()
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
        request.DELETE("/friends/\(currId)/\(id)", parameters: nil, success: {(response: HTTPResponse) -> Void in
            println("Response\(response.responseObject)")
            },failure: {(error: NSError) -> Void in
        })
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var test:Int = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/friends/\(self.currId)")).count
            self.updateCount(test)
            self.tableView.reloadData()
        })
    }
    
    func addFriend(id: String){
        var request = HTTPTask()
        request.responseSerializer = JSONResponseSerializer()
        request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
        request.POST("/friends/\(currId)/\(id)", parameters: nil, success: {(response: HTTPResponse) -> Void in
            println("Response\(response.responseObject)")
            },failure: {(error: NSError) -> Void in
        })
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // self.tableView = nil
            var test:Int = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/friends/\(self.currId)")).count
            self.updateCount(test)
            self.tableView.reloadData()
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
       return 10
    }
    
    func getDistanceFromLatLonInMi(lat1:Double,lon1:Double,lat2:Double,lon2:Double) -> String{
        var R:Double = 6371 // Radius of the earth km
        var dLat = deg2rad(lat2-lat1)  // deg2rad below
        var dLon = deg2rad(lon2-lon1)
        var a = sin(dLat/2) * sin(dLat/2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon/2) * sin(dLon/2)
        var c = 2 * atan2(sqrt(a), sqrt(1-a))
        var d = R * c; // Distance km
        var dInMi = d*0.621371; // American units
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
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var currLng:NSNumber = 0
        var currLat:NSNumber = 0
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
       //  println("currId: " + currId)
        markersDictionary = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/friends/\(currId)"))
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "MyTestCell")
        var name:String = ""
        if(markersDictionary.count>0 && indexPath.row < markersDictionary.count){ //Instead of doing this try to change the table size
            var firstname: String = markersDictionary[indexPath.row]["first_name"] as String
            var lastname: String = markersDictionary[indexPath.row]["last_name"] as String
            var lnglat:NSArray = markersDictionary[indexPath.row]["loc"] as NSArray
            var fbID:String = markersDictionary[indexPath.row]["auth_id"] as String
            var lng:Double = lnglat[0] as Double
            var lat:Double = lnglat[1] as Double
            let location = locationManager.location
            var currentLat:CLLocationDegrees = location.coordinate.latitude
            var currentLng:CLLocationDegrees = location.coordinate.longitude
            var dist = getDistanceFromLatLonInMi(lat, lon1: lng, lat2: currentLat, lon2: currentLng)
            cell.detailTextLabel?.text = dist
            name = (firstname + " " + lastname)
            
            var friendsImage:UIImage = UIImage(named: "Friends")!
            println("id" + fbID)
            
               friendsImage =  UIImage(data: NSData(contentsOfURL: NSURL(string:"https://graph.facebook.com/\(fbID)/picture")!)!)!
              //  println("test1 " + self.finalId)
            
                cell.imageView?.image = friendsImage
            
            
        }
            //NOTE TO FUTURE ME: CHECK FOR NULL STRINGS
            if(countElements(searchName) >= 2){
                var nameArray: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/search/\(searchName)"))
                 println(nameArray)
                updateCount(nameArray.count)
                if tableView == self.searchDisplayController!.searchResultsTableView {
                    println("here")
                    if(indexPath.row<(nameArray.count)){
                        
                        var firstName:String = nameArray[indexPath.row]["first_name"] as String
                        var lastName:String = nameArray[indexPath.row]["last_name"] as String
                      //  var fbID:String = markersDictionary[indexPath.row]["auth_id"] as String
                        name = firstName + " " + lastName
                        let friendsImage = UIImage(named: "Friends")
                        cell.imageView?.image = friendsImage
                        cell.detailTextLabel?.text = ""
                    }else{
                        
                        name = ""
                        cell.imageView?.image = nil
                        cell.detailTextLabel?.text = ""
                    }
                }
            }
       
            cell.textLabel?.text = name
            tableView.rowHeight = 100
        
        
            
        
        // cell.detailTextLabel?.numberOfLines = 3
        //cell.imageView.image = imageView.image
        
        
        
        // cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) ->[AnyObject]! {
        
        
        
       // println("TEST")
        //updateCount()
        
        //  if(indexPath.row<self.markersDictionaryCount.count){
        
        
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            tableView.editing = false
            var id: String = self.markersDictionary[indexPath.row]["_id"] as String
            self.deleteFriend(id);
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: deleteClosure)
        
        
        // }
        
        
        return [deleteAction]
    }
    
    
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            var nameArray: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/search/\(self.searchName)"))
            var id: String = nameArray[indexPath.row]["_id"] as String
            friendId = id
            var name: String = nameArray[indexPath.row]["first_name"] as String
            var sheet: UIActionSheet = UIActionSheet()
            let title: String = "Would You Like To Add "
            let title2: String = "?"
            sheet.title  = (title + name + title2)
            sheet.addButtonWithTitle("Add")
            sheet.addButtonWithTitle("Not Now")
            sheet.cancelButtonIndex = 1
            sheet.delegate = self                  // new line here
            sheet.tag = 1                          // another new line here
            sheet.showInView(self.view)
            
            
            // self.addFriend(id)
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        
        if(buttonIndex == 0){
            addFriend(friendId)
        }
    }
    
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        searchName = searchString
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        // self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        
        //  searchName = self.searchDisplayController!.searchBar.text
        
        return true
    }
    
}
