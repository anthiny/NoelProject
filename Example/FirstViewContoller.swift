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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Info")
        
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            persons = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
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