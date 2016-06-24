//
//  AddViewContoller.swift
//  Example
//
//  Created by Anthony Kim n on 2016. 6. 24..
//  Copyright © 2016년 Anthony Kim n. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddViewController: UIViewController{
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var phoneNumberTextBox: UITextField!
    @IBOutlet weak var companyNameTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func test(sender: AnyObject) {
          let infoModel = ContactInfo(name: nameTextBox.text! , phoneNumber: phoneNumberTextBox.text!, companyName: companyNameTextBox.text!, email: emailTextBox.text!)
        
        saveName(infoModel)
        
    }
    
    func saveName(info: ContactInfo){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Info", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(info.name, forKey: "name")
        person.setValue(Int(info.phoneNumber!), forKey: "phoneNumber")
        person.setValue(info.companyName, forKey: "companyName")
        person.setValue(info.email, forKey: "email")
        
        do{
            try managedContext.save()
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    

}
