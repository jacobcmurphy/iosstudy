//
//  Entity.swift
//  wgo
//
//  Created by Sharat Sridhar on 10/15/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import Foundation
import CoreData

class Entity: NSManagedObject {

    @NSManaged var first_name: String
    @NSManaged var id: String
    @NSManaged var last_name: String
    @NSManaged var long: NSNumber
    @NSManaged var lat: NSNumber
    
    


}
