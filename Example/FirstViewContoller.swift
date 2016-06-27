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
    
    func coreDataFetch() {
        
        let fetchRequest = NSFetchRequest(entityName: "Info")
        
        do{
            let results = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            persons = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not Load Core Data \(error), \(error.userInfo)")
        }
    }
    
    func coreDataSave() {
        
        do{
            try appDelegate.managedObjectContext.save()
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let itemToDelete = persons[indexPath.row]
            
            appDelegate.managedObjectContext.deleteObject(itemToDelete)
            
            coreDataSave()
            
            coreDataFetch()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
    }
    
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
        return cell
    }
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        self.dismissViewControllerAnimated(true, completion:
            { [unowned self] () -> Void in
                let resultStrings = result.value.componentsSeparatedByString("$")
                if resultStrings.count != 4 {
                    print("Information's Index is not Enough!")
                }
                else{
                    let info = ContactInfo(name: resultStrings[0], phoneNumber: resultStrings[1], companyName: resultStrings[2], email: resultStrings[3])
                    self.saveInfo(info)
                }
            })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveInfo(info: ContactInfo){
        
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
            let alert = UIAlertController(title: "QRCodeReader", message: "Success Add New Info", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: {self.tableView.reloadData()})
        } catch let error as NSError{
            let alert = UIAlertController(title: "QRCodeReader Error", message: String(error.code), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}