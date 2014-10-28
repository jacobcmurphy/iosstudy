//
//  Poster.swift
//  wgo
//
//  Created by David Giliotti on 10/7/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import Foundation

public class Poster {
    
    class func getIP () -> String {
        return "http://leiner.cs-i.brandeis.edu:6000"
    }
    
    /* Parsing Stuff */
    class func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    class func parseJSON(inputData: NSData) -> NSArray{
        var error: NSError?
        var boardsDictionary: NSArray = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
       // var latlng:NSArray = boardsDictionary[3]["loc"] as NSArray
       // println(boardsDictionary)
        return boardsDictionary
    }
    /* End Of Parsing Stuff*/


}
