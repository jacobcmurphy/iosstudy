//
//  EventsViewController.swift
//  wgo
//
//  Created by David Giliotti on 11/3/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import UIKit
import Foundation


class EventsViewController: UIViewController, UITableViewDelegate, NSXMLParserDelegate{
    
    
    /**RSS**/
    var parser = NSXMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var fdescription = NSMutableString()
    
    @IBOutlet weak var tableView: UITableView!

 override func viewDidLoad() {
    
    feeds = []
    var url: NSURL = NSURL(string: "http://25livepub.collegenet.com/calendars/campus.rss")!
    parser = NSXMLParser (contentsOfURL: url)!
    parser.delegate = self
    parser.shouldProcessNamespaces = false
    parser.shouldReportNamespacePrefixes = false
    parser.shouldResolveExternalEntities = false
    parser.parse()
    
    super.viewDidLoad()
    
    
    }
    
    
    
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
        
        let myRedColor = UIColor(red:0xec/255, green:0xf0/255,blue:0xf2/255,alpha:1.0)
        cell.backgroundColor = myRedColor
        let myRedColor1 = UIColor(red:0x0b/255, green:0x6a/255,blue:0xff/255,alpha:1.0)
        cell.textLabel.textColor = myRedColor1
        tableView.backgroundColor = myRedColor
        cell.detailTextLabel?.numberOfLines = 3
        // cell.detailTextLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("description") as NSString
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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
        let title = feeds.objectAtIndex(indexPath.row).objectForKey("title") as NSString
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        //println("You selected cell #\(indexPath.row)!")
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) ->[AnyObject]! {
        
        var pinAction = UITableViewRowAction(style: .Default, title: "Pin") { (action, indexPath) -> Void in
            tableView.editing = false
            
         
        }
        let myRedColor = UIColor(red:0xcc/255, green:0x66/255,blue:0x00/255,alpha:1.0)
        pinAction.backgroundColor = UIColor.orangeColor()
        
        return [pinAction]
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    





}