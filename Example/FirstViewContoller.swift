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
import AVFoundation
import Alamofire

class FirstViewController: UITableViewController, QRCodeReaderViewControllerDelegate, UISearchResultsUpdating {
    /**
     Tells the delegate that the camera was switched by the user
     
     - parameter reader: A code reader object informing the delegate about the scan result.
     - parameter newCaptureDevice: The capture device that was switched to
     */
    public func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }


    var persons = [ContactInfo]()
    var filteredPersons = [ContactInfo]()
    
    lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
    })    
    
    let searchController = UISearchController(searchResultsController: nil)
    let userID = UIDevice.current.identifierForVendor!.uuidString
    let URL = "https://omegaapp.herokuapp.com/person/"
    let divid = 100000000
    
    var isNotFirst = true
    
    //getAPi
    func getAPI(){
        let hashedUserID = userID.hashValue%divid
        let requestURL = URL+"\(hashedUserID)"
        print(requestURL)
        Alamofire.request(requestURL)
            .responseJSON { response in
                print("get-\(response.result)")   // result of response serialization
                if let JSON = response.result.value {
                    self.convertResponseData(JSON as AnyObject)
                    print(JSON)
                }
                else{
                    self.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "Error !", message: "You can't access to server. \n Check Your Internet", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(UIAlertAction) in exit(0)}))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    //Json to persons's Array
    func convertResponseData(_ responseData: AnyObject) {
        if let infoDict = responseData["info"] as? [AnyObject] {
            for dict2 in infoDict{
                let name = dict2["name"] as? String
                let phoneNumber = dict2["phone"] as? String
                let companyName = dict2["companyName"] as? String
                let email = dict2["email"] as? String
                let newPerson = ContactInfo(name: name!, phoneNumber: phoneNumber!, companyName: companyName!, email: email!)
                persons.append(newPerson)
            }
            dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }
    }
    
    //Add API
    func addAPI(_ target: ContactInfo, reader: QRCodeReaderViewController){
        let hashedUserID = userID.hashValue%divid
        let targetPhone = target.phoneNumber
        let requestURL = URL+"\(hashedUserID)/info/\(targetPhone)"
        _ = [
            "name": target.name,
            "phone": target.phoneNumber,
            "companyName": target.companyName,
            "email": target.email
        ]
        Alamofire.request(requestURL)
            .responseJSON { response in
                print("add-\(response.result)")   // result of response serialization
                if response.result.value != nil {
                    let alert = UIAlertController(title: "Success Add New Item!", message: "Add \(target.name)'s Info", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) in
                        self.persons.append(target)
                        self.dismiss(animated: true, completion: nil)
                    }))
                    reader.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Failed Add New Item to Serever", message: "Check your Internet!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) in self.dismiss(animated: true, completion: nil)}))
                    reader.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    //DeleteAPI
    func deleteAPI(_ target: ContactInfo, indexPath: IndexPath){
        let hashedUserID = userID.hashValue%divid
        let requestURL = URL+"\(hashedUserID)/info/\(target.phoneNumber)"
     
        Alamofire.request(requestURL)
            .responseJSON { response in
                print("delete-\(response.result)")   // result of response serialization
                if response.result.value != nil {
                    let alert = UIAlertController(title: "Success Delete Item!", message: "\(target.name) Item is deleted", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(UIAlertAction) in
                        self.persons.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        //Add searchBar
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNotFirst{
            getAPI()
            let alertController = UIAlertController(title: "Load Data", message: "Loading.....", preferredStyle: UIAlertControllerStyle.alert)
            present(alertController, animated: true, completion: nil)
            isNotFirst = false
        }
    }
    
    //SearchBar Filter
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPersons = persons.filter { person in
            return (person.name.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setEditing(false, animated: true)
    }

    //updating SearchResult
    func updateSearchResults(for searchController: UISearchController) {
        if isEditing == true{
            setEditing(false, animated: true)
        }
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    //Table Editing (delete)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let target = persons[indexPath.row]
            deleteAPI(target, indexPath: indexPath)
        }
    }
    
    //Open QRCodeScan View
    @IBAction func openAddView(_ sender: AnyObject)
    {
        if QRCodeReader.isAvailable() && QRCodeReader.supportsMetadataObjectTypes() {
            readerVC.delegate = self
            readerVC.modalPresentationStyle = .formSheet
            present(readerVC, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Error !", message: "You can't use QRCodeReader. \n Check Your Device!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if checkSearchBarUsing() {
            return filteredPersons.count
        }
        return persons.count
    }
    
    //Setting tableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    //Perpare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as? DetailViewController{
                if let selectedRow = (sender as? IndexPath)?.row{
                    let selectedItem: ContactInfo
                    
                    if checkSearchBarUsing(){
                        selectedItem = filteredPersons[selectedRow]
                    }else{
                         selectedItem = persons[selectedRow]
                    }
        
                    if selectedItem.name.isEmpty || selectedItem.phoneNumber.isEmpty || selectedItem.companyName.isEmpty || selectedItem.email.isEmpty{
                        let alert = UIAlertController(title: "Error !", message: "Selected Cell does not have Enough Information", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
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
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        let resultStrings = result.value.components(separatedBy: "$")
        if resultStrings.count != 4 {
            let alert = UIAlertController(title: "QRCodeReader Error", message: "Information's Index is not Match!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) in self.dismiss(animated: true, completion: nil)}))
            reader.present(alert, animated: true, completion: nil)
        }
        else{
            let info = ContactInfo(name: resultStrings[0], phoneNumber: resultStrings[1], companyName: resultStrings[2], email: resultStrings[3])
            if checkDuplication(info.phoneNumber, email: info.email){
                let alert = UIAlertController(title: "Failed Add New Item", message: "Same PhoneNumber or Same Email already exist", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action: UIAlertAction) in self.dismiss(animated: true, completion: nil)}))
                reader.present(alert, animated: true, completion: nil)
            }
            else{
                self.addAPI(info, reader: reader)
            }
        }
    }
    
    //Cancel button func which is in the QRScan View
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Check Duplication before Add
    func checkDuplication(_ phoneNumber: String, email: String) -> Bool{
        for person in persons{
            if person.phoneNumber == phoneNumber || person.email == email{
                return true
            }
        }
        return false
    }
    
    //check Search Bar Using
    func checkSearchBarUsing() -> Bool{
        if searchController.isActive && searchController.searchBar.text != ""{
            return true
        }else{
            return false
        }
    }
}
