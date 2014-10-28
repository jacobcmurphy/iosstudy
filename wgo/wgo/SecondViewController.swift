//
//  SecondViewController.swift
//  wgo
//
//  Created by David Giliotti on 9/4/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController,
UITableViewDelegate {
    
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
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection section: Int) -> Int {
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        var currId:String = ""
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
            currId = fetchResults[0].id
        }
        var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/\(currId)/friends"))
        return markersDictionary.count
        
    
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let fetchRequest = NSFetchRequest(entityName: "UserEn")
        var currId:String = ""
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [UserEn] {
            currId  = fetchResults[0].id
        }
        var markersDictionary: NSArray = Poster.parseJSON(Poster.getJSON(Poster.getIP() + "/users/\(currId)/friends"))
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        var firstname: String = markersDictionary[indexPath.row]["first_name"] as String
        var lastname: String = markersDictionary[indexPath.row]["last_name"] as String
        cell.textLabel.text = (firstname + " " + lastname)
        cell.detailTextLabel?.numberOfLines = 3
        // cell.detailTextLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("description") as NSString
        
        return cell
            
        
    }


}

