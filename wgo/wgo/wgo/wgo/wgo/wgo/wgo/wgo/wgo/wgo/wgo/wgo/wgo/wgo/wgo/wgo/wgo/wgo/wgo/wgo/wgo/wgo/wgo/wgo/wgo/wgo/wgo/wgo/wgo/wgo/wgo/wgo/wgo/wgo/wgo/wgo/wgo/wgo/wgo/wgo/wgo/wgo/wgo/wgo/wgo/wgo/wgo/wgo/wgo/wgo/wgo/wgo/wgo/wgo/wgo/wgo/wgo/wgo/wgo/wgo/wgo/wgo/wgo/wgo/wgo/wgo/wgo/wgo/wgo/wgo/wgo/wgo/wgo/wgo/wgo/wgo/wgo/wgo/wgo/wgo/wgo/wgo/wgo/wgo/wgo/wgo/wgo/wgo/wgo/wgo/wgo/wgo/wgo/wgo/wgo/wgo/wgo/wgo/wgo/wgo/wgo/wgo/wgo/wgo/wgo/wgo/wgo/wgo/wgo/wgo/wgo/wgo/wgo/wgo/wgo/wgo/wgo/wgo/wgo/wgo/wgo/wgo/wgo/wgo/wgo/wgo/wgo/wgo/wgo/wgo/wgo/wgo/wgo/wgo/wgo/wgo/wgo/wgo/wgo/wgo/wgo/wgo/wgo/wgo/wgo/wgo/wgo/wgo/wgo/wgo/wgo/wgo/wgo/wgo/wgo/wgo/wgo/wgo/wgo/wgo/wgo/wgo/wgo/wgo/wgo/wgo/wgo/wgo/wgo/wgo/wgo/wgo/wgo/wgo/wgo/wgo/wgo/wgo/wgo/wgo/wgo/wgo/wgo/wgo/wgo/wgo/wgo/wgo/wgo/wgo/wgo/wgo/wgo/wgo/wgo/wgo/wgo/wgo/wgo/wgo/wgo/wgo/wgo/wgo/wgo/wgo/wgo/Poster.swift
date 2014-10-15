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
    
//    class func post(params : Dictionary<String, String>, url : String) -> NSURLResponse? {
//    //example self.put(["first_name":"FirstName", "last_name":"LastName"]
//        
//        var fullURL:String = self.getIP()
//        fullURL += url
//        println(fullURL)
//        var request = NSMutableURLRequest(URL: NSURL(string: fullURL))
//        var session = NSURLSession.sharedSession()
//        request.HTTPMethod = "POST"
//        
//        var err: NSError?
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        
//        
//        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            println("Response: \(response)")
//            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            // println("Body: \(strData)")
//            if strData.lowercaseString.rangeOfString("failed") != nil { // check results for failed server authentication
//                println("authentication failed. successfully connected to server.")
//            }
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
//
//            //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myDictionary
//            //options:0
//            //error:&amp;error];
//            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
//            if(err != nil) {
//                println(err!.localizedDescription)
//                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                println("Error could not parse JSON: '\(jsonStr)'")
//            }
//            else {
//                // The JSONObjectWithData constructor didn't return an error. But, we should still
//                // check and make sure that json has a value using optional binding.
//                if let parseJSON = json {
//                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
//                    var success = parseJSON["success"] as? Int
//                    println("Succes: \(success)")
//                }
//                else {
//                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                    println("Error could not parse JSON: \(jsonStr)")
//                }
//            }
//        })
//    
//        task.resume()
//println("Task Response: \(task.response)") // Need to fix this because task response cannot be converted to string PRIORITY 1
//        return task.response
//        //return
//    }

}
