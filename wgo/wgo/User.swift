//
//  User.swift
//  wgo
//
//  Created by David Giliotti on 10/7/14.
//  Copyright (c) 2014 DJSS. All rights reserved.
//

import Foundation

class User {
    
    var id: String
    var first_name: String
    var last_name: String
    var loc:Array<Double>
    
    init(id:String, first_name:String, last_name:String, loc:Array<Double>){
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.loc = loc
    }
    
    func getID() -> String {
        return self.id
    }
    
    func getFirstName() -> String {
        return self.first_name
    }
    
    func getLastName() -> String {
        return self.last_name
    }
    
    func getFullName() -> String {
        return self.first_name + " " + self.last_name
    }
    
    func getLong() -> double_t {
        return loc[0]
    }
    
    func getLat() -> double_t {
        return loc[1]
    }
    
    func setLoc(longDoub:Double, latDoub:Double){
        loc[0] = longDoub
        loc[1] = latDoub
    }
    
}