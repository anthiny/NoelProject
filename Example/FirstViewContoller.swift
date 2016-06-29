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

class FirstViewController: UITableViewController, QRCodeReaderViewControllerDelegate, UISearchResultsUpdating {
    
    var persons = [NSManagedObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate    
    lazy var readerVC = QRCodeReaderViewController(cancelButtonTitle: "Cancel", codeReader: QRCodeReader(), startScanningAtLoad: true, showSwitchCameraButton: false, showTorchButton: false)
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPersons = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        saveDummy()
        //Add searchBar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    //SearchBar Filter
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPersons = persons.filter { person in
            return (person.valueForKey("name")?.lowercaseString.containsString(searchText.lowercaseString))!
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        coreDataFetch()
        self.tableView.reloadData()
    }
    
    //updating SearchResult
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
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
        
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPersons.count
        }
        return persons.count
    }
    
    //Setting tableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let person: NSManagedObject
        if searchController.active && searchController.searchBar.text != "" {
            person = filteredPersons[indexPath.row]
        } else {
            person = persons[indexPath.row]
        }
        cell.textLabel?.text = person.valueForKey("name") as? String
        cell.detailTextLabel?.text = person.valueForKey("phoneNumber") as? String
        return cell
    }
    
    //Open DetailView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: indexPath)
    }
    
    //Perpare Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destinationViewController as? DetailViewController{
                searchController.active = false
                let selectedRow = (sender as? NSIndexPath)?.row
                
                if let name = persons[selectedRow!].valueForKey("name") as? String {
                    destinationVC.nameInfoLabel.text = name
                }else{
                    print("name is null")
                }
                
                if let name = persons[selectedRow!].valueForKey("phoneNumber") as? String {
                    destinationVC.phoneNumberInfoLabel.text = name
                }else{
                    print("phoneNumber is null")
                }
                
                if let name = persons[selectedRow!].valueForKey("companyName") as? String {
                    destinationVC.companyNameInfoLabel.text = name
                }else{
                    print("companyName is null")
                }
                
                if let name = persons[selectedRow!].valueForKey("email") as? String {
                    destinationVC.emailInfoLabel.text = name
                }else{
                    print("email is null")
                }
            }
        }
    }
    
    //When QRreader read QRcode
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
    
    //Cancel button func which is in the QRScan View
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //make a dummy
    func saveDummy()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Info", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue("lee", forKey: "name")
        person.setValue("01042413030", forKey: "phoneNumber")
        person.setValue("사람", forKey: "companyName")
        person.setValue("aaa@naver.com", forKey: "email")

    }
    
    //save to coredata
    func saveInfo(info: ContactInfo, reader: QRCodeReaderViewController) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Info", inManagedObjectContext: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        person.setValue(info.name, forKey: "name")
        person.setValue(info.phoneNumber, forKey: "phoneNumber")
        person.setValue(info.companyName, forKey: "companyName")
        person.setValue(info.email, forKey: "email")
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