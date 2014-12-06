//
//  AppDelegate.swift
//  wgo
//
//  Created by David Giliotti on 9/4/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import SwiftHTTP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    let service = "WGO"
    let userAccount = "WGOUser"
    let key = "wgoAuth"
    var currId = ""
    
    var window: UIWindow?
    
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        
        FBLoginView.self
        FBProfilePictureView.self
        
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

    func applicationDidEnterBackground(application: UIApplication!) {
        
        let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
        let (dictionary, error) = Locksmith.performRequest(readRequest)
        if (dictionary?.valueForKey("appId") as String != "") {
            let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            dispatch_async(dispatch_get_main_queue(), {
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("updateBackground"), userInfo: nil, repeats: true)
                })
            })
        }
    }
    
    
    func updateBackground(){
        var locationManager = CLLocationManager()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            let location = locationManager.location
            var currentLat:CLLocationDegrees = location.coordinate.latitude
            var currentLng:CLLocationDegrees = location.coordinate.longitude
            var curDoubLat:double_t = currentLat as double_t
            var curDoubLong:double_t = currentLng as double_t
            let locString = NSString(format: "[%f, %f]", curDoubLong, curDoubLat)
            var request = HTTPTask()
            request.responseSerializer = JSONResponseSerializer()
            request.baseURL = "http://leiner.cs-i.brandeis.edu:6000"
            
            let readRequest = LocksmithRequest(service: service, userAccount: userAccount, key: key)
            let (dictionary, error) = Locksmith.performRequest(readRequest)
            if (dictionary?.valueForKey("appId") as String != "") {
                self.currId = dictionary?.valueForKey("appId") as String!
                request.POST("/users/\(self.currId)", parameters: ["loc": locString], success: {(response: HTTPResponse) -> Void in
                println("Response\(response.responseObject)")
                },failure: {(error: NSError) -> Void in
            })
            println(locString)
            }
        }
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        return wasHandled
    }


}

