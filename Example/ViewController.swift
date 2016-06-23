//
//  ViewController.swift
//  Example
//
//  Created by Anthony Kim n on 2016. 6. 22..
//  Copyright © 2016년 Anthony Kim n. All rights reserved.
//

import UIKit
import QRCode

class ViewController: UIViewController {
    
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    
    enum InputError: ErrorType{
        case noName
        case OutOfRange
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func generateButton(sender: AnyObject) {
        do{
            try generatingQRcode()
        }catch InputError.noName{
            showAlert("Your name space is empty")
        }catch InputError.OutOfRange{
            showAlert("PhoneNumber's length is Out Of Range")
        }catch {
            showAlert("Exceptional Error!")
        }
    }
    
    func generatingQRcode() throws{
        
        guard nameTextField.text?.isEmpty == false else {
            throw InputError.noName
        }
        
        guard phoneNumberTextField.text?.characters.count < 12 else {
            throw InputError.OutOfRange
        }
       
        let Info = ContactInfo(name: nameTextField.text!, phoneNumber: phoneNumberTextField.text!, companyName: companyNameTextField.text!, email: nil)
        var qrCodeContents = QRCode(Info.exchangeToQRString())
        qrCodeContents?.color = CIColor(color: UIColor.blueColor())
        qrImage.image=qrCodeContents?.image
    }
    
    func showAlert(title: String, message: String? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    

}

