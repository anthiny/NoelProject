//
//  FirstViewContoller.swift
//  Example
//
//  Created by Anthony Kim n on 2016. 6. 24..
//  Copyright © 2016년 Anthony Kim n. All rights reserved.
//

import Foundation
import UIKit
import QRCodeReader
import Alamofire

class FirstViewController: UITableViewController, QRCodeReaderViewControllerDelegate, UISearchResultsUpdating {

    var persons = [ContactInfo]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate    
    lazy var readerVC = QRCodeReaderViewController(cancelButtonTitle: "Cancel", codeReader: QRCodeReader(), startScanningAtLoad: true, showSwitchCameraButton: false, showTorchButton: false)
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPersons = [ContactInfo]()
    
    let userID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    let divid = 100000000
    
    //getAPi
    func getAPI(){
        let hashedUserID = userID.hashValue%divid
        let requestURL = "https://omegaapp.herokuapp.com/person/\(hashedUserID)"
        print(requestURL)
        Alamofire.request(.GET, requestURL, parameters: nil)
            .responseJSON { response in
                print("get-\(response.result)")   // result of response serialization
                if let JSON = response.result.value {
                    print(JSON)
                }
                else{
                    let alert = UIAlertController(title: "Error !", message: "You can't access to server. \n Check Your Internet", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(UIAlertAction) in exit(0)}))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        }
    }
    
    func convertResponseData(responseData: AnyObject) {
        
        if let infoDict = responseData["info"] as? [AnyObject] {
            for dict2 in infoDict{
                let newPerson = ContactInfo(name: dict2["name"] as! String, phoneNumber: dict2["phoneNumber"] as! String, companyName: dict2["companyName"] as! String, email: dict2["email"] as! String)
                persons.append(newPerson)
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAPI()
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
            return (person.name.lowercaseString.containsString(searchText.lowercaseString))
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    //updating SearchResult
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //CoreData Editing (delete)
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            persons.removeAtIndex(indexPath.row)
            
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
        let person: ContactInfo
        if searchController.active && searchController.searchBar.text != "" {
            person = filteredPersons[indexPath.row]
        } else {
            person = persons[indexPath.row]
        }
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = person.phoneNumber
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

                let selectedRow = (sender as? NSIndexPath)?.row
                
                if let name = persons[selectedRow!].name as? String{
                    destinationVC.nameInfoLabel.text = name
                }else{
                    print("name is null")
                }
                
                if let phoneNumber = persons[selectedRow!].phoneNumber as? String {
                    destinationVC.phoneNumberInfoLabel.text = phoneNumber
                }else{
                    print("phoneNumber is null")
                }
                
                if let companyName = persons[selectedRow!].companyName as? String {
                    destinationVC.companyNameInfoLabel.text = companyName
                }else{
                    print("companyName is null")
                }
                
                if let email = persons[selectedRow!].email as? String {
                    destinationVC.emailInfoLabel.text = email
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
       let dummyPerson = ContactInfo(name: "kim", phoneNumber: "01041095812", companyName: "aaaa", email: "vvv@naver.com")
        persons.append(dummyPerson)

    }
    
    func checkDuplication(phoneNumber: String, email: String) -> Bool{
        for person in persons{
            if person.phoneNumber == phoneNumber || person.email == email{
                return true
            }
        }
        return false
    }
    
    
    //save to coredata
    func saveInfo(info: ContactInfo, reader: QRCodeReaderViewController) {
        if !checkDuplication(info.phoneNumber, email: info.email){
            persons.append(info)
            let alert = UIAlertController(title: "Success Add New Item!", message: "Add \(info.name)'s Info", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in self.dismissViewControllerAnimated(true, completion: nil)}))
            reader.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Failed Add New Item", message: "Same PhoneNumber or Same Email already exist", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in self.dismissViewControllerAnimated(true, completion: nil)}))
            reader.presentViewController(alert, animated: true, completion: nil)
        }
        
    }

}