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

class FirstViewController: UITableViewController {
    
    var persons = [NSManagedObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = self.persons[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = row.valueForKey("name") as? String
        return cell
    }

}