//
//  ViewController.swift
//  Example
//
//  Created by Anthony Kim n on 2016. 6. 22..
//  Copyright © 2016년 Anthony Kim n. All rights reserved.
//

import UIKit
import QRCode
import SnapKit

class ViewController: UIViewController {
    
    var qrImage = UIImageView()
    var inputContentsView = UIView()
    var nameTextField = UITextField()
    var phoneNumberTextField = UITextField()
    var companyNameTextField = UITextField()
    var emailTextField = UITextField()
    var generatingButton = UIButton()
    
    enum InputError: ErrorType{
        case noName
        case noPhoneNumber
        case noCompanyName
        case noEmail
        case OutOfRange
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContentsConstrant()
        //generatingButton.al
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContentsConstrant(){
        let superView = self.view
        
        superView.addSubview(qrImage)
        superView.addSubview(inputContentsView)
        inputContentsView.addSubview(nameTextField)
        inputContentsView.addSubview(phoneNumberTextField)
        inputContentsView.addSubview(companyNameTextField)
        inputContentsView.addSubview(emailTextField)
        superView.addSubview(generatingButton)
        
        qrImage.translatesAutoresizingMaskIntoConstraints = false
        inputContentsView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        companyNameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        generatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        qrImage.backgroundColor = UIColor.whiteColor()
        qrImage.snp_makeConstraints { (make) in
            make.top.equalTo(superView.snp_top).offset(90)
            make.size.equalTo(150*UIScreen.mainScreen().bounds.height/500)
            make.centerX.equalTo(superView.snp_centerX)
        }
        
        inputContentsView.backgroundColor = UIColor.whiteColor()
        inputContentsView.snp_makeConstraints { (make) in
            make.top.equalTo(qrImage.snp_bottom).offset(35)
            make.leading.equalTo(superView.snp_leading).offset(10)
            make.trailing.equalTo(superView.snp_trailing).offset(-10)
            make.bottom.equalTo(superView.snp_bottom).offset(-60)
            make.centerX.equalTo(superView.snp_centerX)
        }
        
        nameTextField.borderStyle = .RoundedRect
        nameTextField.backgroundColor = UIColor.clearColor()
        nameTextField.snp_makeConstraints { (make) in
            make.top.equalTo(inputContentsView.snp_top).offset(5)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.height.equalTo(phoneNumberTextField.snp_height)
        }
        
        phoneNumberTextField.borderStyle = .RoundedRect
        phoneNumberTextField.backgroundColor = UIColor.clearColor()
        phoneNumberTextField.snp_makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp_bottom).offset(3)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.height.equalTo(companyNameTextField.snp_height)
        }
        
        companyNameTextField.borderStyle = .RoundedRect
        companyNameTextField.backgroundColor = UIColor.clearColor()
        companyNameTextField.snp_makeConstraints { (make) in
            make.top.equalTo(phoneNumberTextField.snp_bottom).offset(3)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.height.equalTo(emailTextField.snp_height)
        }
        
        emailTextField.borderStyle = .RoundedRect
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.keyboardType = .EmailAddress
        emailTextField.snp_makeConstraints { (make) in
            make.top.equalTo(companyNameTextField.snp_bottom).offset(3)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.bottom.equalTo(inputContentsView.snp_bottom).offset(-5)
        }
        
        generatingButton.backgroundColor = UIColor.whiteColor()
        generatingButton.setTitle("Let's Do It!", forState: .Normal)
        generatingButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        generatingButton.addTarget(self, action: #selector(generatingQRCode), forControlEvents: .TouchUpInside)
        generatingButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(superView.snp_centerX)
            make.bottom.equalTo(superView.snp_bottom).offset(-10)
        }
    }

    func generatingQRCode(button: UIButton) {
        do{
            try generatingQRcode()
        }catch InputError.noName{
            showAlert("Your name space is empty")
        }catch InputError.noPhoneNumber{
            showAlert("Your PhoneNumber space is empty")
        }
        catch InputError.noCompanyName{
            showAlert("Your CompanyName space is empty")
        }
        catch InputError.noEmail{
            showAlert("Your Email space is empty")
        }
        catch InputError.OutOfRange{
            showAlert("PhoneNumber's length is Out Of Range")
        }catch {
            showAlert("Exceptional Error!")
        }
    }
    
    func generatingQRcode() throws{
        
        guard nameTextField.text?.isEmpty == false else {
            throw InputError.noName
        }
        
        guard phoneNumberTextField.text?.isEmpty == false else {
            throw InputError.noPhoneNumber
        }
        
        guard companyNameTextField.text?.isEmpty == false else {
            throw InputError.noCompanyName
        }
        
        guard emailTextField.text?.isEmpty == false else {
            throw InputError.noEmail
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

