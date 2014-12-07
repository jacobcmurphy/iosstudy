//
//  ViewController.swift
//  PopDatePickerApp
//
//  Created by Valerio Ferrucci on 07/10/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate {
    
    var startPopDatePicker : PopDatePicker?
    var endPopDatePicker : PopDatePicker?
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startPopDatePicker = PopDatePicker(forTextField: startTextField)
        endPopDatePicker = PopDatePicker(forTextField: endTextField)
        startTextField.delegate = self
        endTextField.delegate = self
        
    }
    
    func resign() {
        
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
    
func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    
    if (textField === startTextField) {
        resign()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let initDate = formatter.dateFromString(startTextField.text)
        
        startPopDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField : UITextField) -> () in
            
            // here we don't use self (no retain cycle)
            forTextField.text = newDate.ToDateMediumString()
            
        })
        return false
    }
    if (textField === endTextField) {
        resign()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        let initDate = formatter.dateFromString(endTextField.text)
        endPopDatePicker!.pick(self, initDate:initDate, dataChanged: { (newDate : NSDate, forTextField : UITextField) -> () in
            
            // here we don't use self (no retain cycle)
            forTextField.text = newDate.ToDateMediumString()
        })
        return false
    }
  
        return true
    
}
    
    @IBAction func save(sender: AnyObject) {
        
        var msg : String
        if (startTextField.text != "") {
            msg = titleTextField.text + " " + startTextField.text
        } else {
            msg = "Date empty!"
        }
        let alert:UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:.Alert)
        alert.addAction(UIAlertAction(title: "Event Added!", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        self.presentViewController(alert, animated:true, completion:nil);
        
    }
}

