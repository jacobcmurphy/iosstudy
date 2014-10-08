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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
               // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            
            println("gcd hello")
            dispatch_async(dispatch_get_main_queue(), {
                var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateBackground"), userInfo: nil, repeats: true)
                println("hello from UI thread executed as dispatch")
                
            })
        })
        println("hello from UI thread")
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
            println(locString)
            Poster.post(["loc": locString], url: "users/5418fcc9947f56e85137d5bb")
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

}

