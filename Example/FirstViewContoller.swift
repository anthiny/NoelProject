//
//  FirstViewContoller.swift
//  Example
//
//  Created by Anthony Kim n on 2016. 6. 24..
//  Copyright © 2016년 Anthony Kim n. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import QRCodeReader

class FirstViewController: UITableViewController, QRCodeReaderViewControllerDelegate {
    
    var persons = [NSManagedObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    lazy var readerVC = QRCodeReaderViewController(cancelButtonTitle: "취소", codeReader: QRCodeReader(), startScanningAtLoad: true, showSwitchCameraButton: false, showTorchButton: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        coreDataFetch()
        self.tableView.reloadData()
    }
    
    //CoreData Loading
    func coreDataFetch() {
        
        let fetchRequest = NSFetchRequest(entityName: "Info")
        
        do{
            let results = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            persons = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not Load Core Data \(error), \(error.userInfo)")
        }
    }
    
    //CoreData Saving
    func coreDataSave() {
        
        do{
            try appDelegate.managedObjectContext.save()
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    //CoreData Editing (delete)
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let itemToDelete = persons[indexPath.row]
            
            appDelegate.managedObjectContext.deleteObject(itemToDelete)
            
            coreDataSave()
            
            coreDataFetch()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
    }
    
    //Open QRCodeScan View
    @IBAction func openAddView(sender: AnyObject)
    {
        if QRCodeReader.isAvailable() && QRCodeReader.supportsMetadataObjectTypes() {
            readerVC.delegate = self
            readerVC.modalPresentationStyle = .FormSheet
            presentViewController(readerVC, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Error !", message: "You can't use QRCodeReader. \n Check Your Device!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = self.persons[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = row.valueForKey("name") as? String
        cell.detailTextLabel?.text = row.valueForKey("phoneNumber") as? String
        return cell
    }
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        let resultStrings = result.value.componentsSeparatedByString("$")
        if resultStrings.count != 4 {
            let alert = UIAlertController(title: "QRCodeReader Error", message: "Information's Index is not Match!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in self.dismissViewControllerAnimated(true, completion: nil)}))
            reader.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let info = ContactInfo(name: resultStrings[0], phoneNumber: resultStrings[1], companyName: resultStrings[2], email: resultStrings[3])
            self.saveInfo(info, reader: reader)
        }
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveInfo(info: ContactInfo, reader: QRCodeReaderViewController) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Info", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(info.name, forKey: "name")
        person.setValue(info.phoneNumber, forKey: "phoneNumber")
        person.setValue(info.companyName, forKey: "companyName")
        person.setValue(info.email, forKey: "email")
        print(person.valueForKey("phoneNumber"))
        do{
            try managedContext.save()
            let alert = UIAlertController(title: "Success Add New Item!", message: "Add \(info.name)'s Info", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in self.dismissViewControllerAnimated(true, completion: nil)}))
            reader.presentViewController(alert, animated: true, completion: nil)
        } catch let error as NSError{
            let alert = UIAlertController(title: "QRCodeReader Error", message: "Error code: \(error.code)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in self.dismissViewControllerAnimated(true, completion: nil)}))
            reader.presentViewController(alert, animated: true, completion: nil)
        }
    }

}