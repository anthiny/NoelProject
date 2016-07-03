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
    var filteredPersons = [ContactInfo]()

    lazy var readerVC = QRCodeReaderViewController(cancelButtonTitle: "Cancel", codeReader: QRCodeReader(), startScanningAtLoad: true, showSwitchCameraButton: false, showTorchButton: false)
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let userID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    let URL = "https://omegaapp.herokuapp.com/person/"
    let divid = 100000000
    
    var isNotFirst = true
    
    //getAPi
    func getAPI(){
        let hashedUserID = userID.hashValue%divid
        let requestURL = URL+"\(hashedUserID)"
        print(requestURL)
        Alamofire.request(.GET, requestURL, parameters: nil)
            .responseJSON { response in
                print("get-\(response.result)")   // result of response serialization
                if let JSON = response.result.value {
                    self.convertResponseData(JSON)
                    print(JSON)
                }
                else{
                    self.dismissViewControllerAnimated(true, completion: nil)
                    let alert = UIAlertController(title: "Error !", message: "You can't access to server. \n Check Your Internet", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(UIAlertAction) in exit(0)}))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        }
    }
    
    //Json to persons's Array
    func convertResponseData(responseData: AnyObject) {
        if let infoDict = responseData["info"] as? [AnyObject] {
            for dict2 in infoDict{
                let name = dict2["name"] as? String
                let phoneNumber = dict2["phone"] as? String
                let companyName = dict2["companyName"] as? String
                let email = dict2["email"] as? String
                let newPerson = ContactInfo(name: name!, phoneNumber: phoneNumber!, companyName: companyName!, email: email!)
                persons.append(newPerson)
            }
            dismissViewControllerAnimated(true, completion: nil)
            self.tableView.reloadData()
        }
    }
    
    //Add API
    func addAPI(target: ContactInfo, reader: QRCodeReaderViewController){
        let hashedUserID = userID.hashValue%divid
        let targetPhone = target.phoneNumber
        let requestURL = URL+"\(hashedUserID)/info/\(targetPhone)"
        let parameters = [
            "name": target.name,
            "phone": target.phoneNumber,
            "companyName": target.companyName,
            "email": target.email
        ]
        Alamofire.request(.POST, requestURL, parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                print("add-\(response.result)")   // result of response serialization
                if let JSON = response.result.value {
                    let alert = UIAlertController(title: "Success Add New Item!", message: "Add \(target.name)'s Info", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in
                        self.persons.append(target)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    reader.presentViewController(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Failed Add New Item to Serever", message: "Check your Internet!", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in self.dismissViewControllerAnimated(true, completion: nil)}))
                    reader.presentViewController(alert, animated: true, completion: nil)
                }
        }
    }
    
    //DeleteAPI
    func deleteAPI(target: ContactInfo, indexPath: NSIndexPath){
        let hashedUserID = userID.hashValue%divid
        let requestURL = URL+"\(hashedUserID)/info/\(target.phoneNumber)"
        
        Alamofire.request(.DELETE, requestURL, parameters: nil)
            .responseJSON { response in
                print("delete-\(response.result)")   // result of response serialization
                if let JSON = response.result.value {
                    let alert = UIAlertController(title: "Success Delete Item!", message: "\(target.name) Item is deleted", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(UIAlertAction) in
                        self.persons.removeAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        //Add searchBar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(animated: Bool) {
        if isNotFirst{
            getAPI()
            let alertController = UIAlertController(title: "Load Data", message: "Loading.....", preferredStyle: UIAlertControllerStyle.Alert)
            presentViewController(alertController, animated: true, completion: nil)
            isNotFirst = false
        }
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
    
    override func viewWillDisappear(animated: Bool) {
        setEditing(false, animated: true)
    }

    //updating SearchResult
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if editing == true{
            setEditing(false, animated: true)
        }
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //Table Editing (delete)
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print(editingStyle)
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let target = persons[indexPath.row]
            deleteAPI(target, indexPath: indexPath)
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
        if checkSearchBarUsing() {
            return filteredPersons.count
        }
        return persons.count
    }
    
    //Setting tableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let person: ContactInfo
        if checkSearchBarUsing() {
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
                if let selectedRow = (sender as? NSIndexPath)?.row{
                    let selectedItem: ContactInfo
                    
                    if checkSearchBarUsing(){
                        selectedItem = filteredPersons[selectedRow]
                    }else{
                         selectedItem = persons[selectedRow]
                    }
        
                    if selectedItem.name.isEmpty || selectedItem.phoneNumber.isEmpty || selectedItem.companyName.isEmpty || selectedItem.email.isEmpty{
                        let alert = UIAlertController(title: "Error !", message: "Selected Cell does not have Enough Information", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                        presentViewController(alert, animated: true, completion: nil)
                    }
                    else{
                        destinationVC.nameInfoLabel.text = selectedItem.name
                        destinationVC.phoneNumberInfoLabel.text = selectedItem.phoneNumber
                        destinationVC.companyNameInfoLabel.text = selectedItem.companyName
                        destinationVC.emailInfoLabel.text = selectedItem.email
                    }
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
            if checkDuplication(info.phoneNumber, email: info.email){
                let alert = UIAlertController(title: "Failed Add New Item", message: "Same PhoneNumber or Same Email already exist", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {(action: UIAlertAction) in self.dismissViewControllerAnimated(true, completion: nil)}))
                reader.presentViewController(alert, animated: true, completion: nil)
            }
            else{
                self.addAPI(info, reader: reader)
            }
        }
    }
    
    //Cancel button func which is in the QRScan View
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Check Duplication before Add
    func checkDuplication(phoneNumber: String, email: String) -> Bool{
        for person in persons{
            if person.phoneNumber == phoneNumber || person.email == email{
                return true
            }
        }
        return false
    }
    
    //check Search Bar Using
    func checkSearchBarUsing() -> Bool{
        if searchController.active && searchController.searchBar.text != ""{
            return true
        }else{
            return false
        }
    }
}
