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

class ViewController: UIViewController, UITextFieldDelegate {
    
    var qrImage = UIImageView()
    var inputContentsView = UIView()
    var nameTextField = UITextField()
    var nameLabel = UILabel()
    var phoneNumberTextField = UITextField()
    var phoneNumberLabel = UILabel()
    var companyNameTextField = UITextField()
    var companyNameLabel = UILabel()
    var emailTextField = UITextField()
    var emailLabel = UILabel()
    var generatingButton = UIButton()
    var saveButton = UIButton()
    
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
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        companyNameTextField.delegate = self
        emailTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setContentsConstrant(){
        let superView = self.view
        
        superView.addSubview(qrImage)
        superView.addSubview(inputContentsView)
        inputContentsView.addSubview(nameTextField)
        inputContentsView.addSubview(nameLabel)
        inputContentsView.addSubview(phoneNumberTextField)
        inputContentsView.addSubview(phoneNumberLabel)
        inputContentsView.addSubview(companyNameTextField)
        inputContentsView.addSubview(companyNameLabel)
        inputContentsView.addSubview(emailTextField)
        inputContentsView.addSubview(emailLabel)
        superView.addSubview(generatingButton)
        superView.addSubview(saveButton)
        
        qrImage.translatesAutoresizingMaskIntoConstraints = false
        inputContentsView.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameTextField.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        generatingButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        nameLabel.text = "Name"
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(inputContentsView.snp_top).offset(5)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(phoneNumberLabel.snp_height)
        }
        
        nameTextField.borderStyle = .RoundedRect
        nameTextField.backgroundColor = UIColor.clearColor()
        nameTextField.snp_makeConstraints { (make) in
            make.top.equalTo(inputContentsView.snp_top).offset(5)
            make.leading.equalTo(nameLabel.snp_trailing).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.height.equalTo(phoneNumberTextField.snp_height)
        }
        
        phoneNumberLabel.text = "Phone"
        phoneNumberLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(6)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.width.equalTo(nameLabel.snp_width)
            make.height.equalTo(companyNameLabel.snp_height)
        }
        
        phoneNumberTextField.borderStyle = .RoundedRect
        phoneNumberTextField.backgroundColor = UIColor.clearColor()
        phoneNumberTextField.snp_makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp_bottom).offset(3)
            make.leading.equalTo(phoneNumberLabel.snp_trailing).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.height.equalTo(companyNameTextField.snp_height)
        }
        
        companyNameLabel.text = "Company"
        companyNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(phoneNumberLabel.snp_bottom).offset(6)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.width.equalTo(phoneNumberLabel.snp_width)
            make.height.equalTo(emailLabel.snp_height)
        }
        
        companyNameTextField.borderStyle = .RoundedRect
        companyNameTextField.backgroundColor = UIColor.clearColor()
        companyNameTextField.snp_makeConstraints { (make) in
            make.top.equalTo(phoneNumberTextField.snp_bottom).offset(3)
            make.leading.equalTo(companyNameLabel.snp_trailing).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.height.equalTo(emailTextField.snp_height)
        }
        
        emailLabel.text = "Email"
        emailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp_bottom).offset(6)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.width.equalTo(companyNameLabel.snp_width)
            make.bottom.equalTo(inputContentsView.snp_bottom).offset(-5)
        }
        
        emailTextField.borderStyle = .RoundedRect
        emailTextField.backgroundColor = UIColor.clearColor()
        emailTextField.keyboardType = .EmailAddress
        emailTextField.snp_makeConstraints { (make) in
            make.top.equalTo(companyNameTextField.snp_bottom).offset(3)
            make.leading.equalTo(emailLabel.snp_trailing).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.bottom.equalTo(inputContentsView.snp_bottom).offset(-5)
        }
        
        generatingButton.backgroundColor = UIColor.whiteColor()
        generatingButton.setTitle("MAKE", forState: .Normal)
        generatingButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        generatingButton.addTarget(self, action: #selector(generatingQRCode), forControlEvents: .TouchUpInside)
        generatingButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(superView.snp_centerX)
            make.bottom.equalTo(superView.snp_bottom).offset(-10)
        }
        
        saveButton.backgroundColor = UIColor.whiteColor()
        saveButton.setTitle("SAVE", forState: .Normal)
        saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveButton.addTarget(self, action: #selector(saveQRCode), forControlEvents: .TouchUpInside)
        saveButton.snp_makeConstraints { (make) in
            make.leading.equalTo(generatingButton.snp_trailing).offset(10)
            make.bottom.equalTo(superView.snp_bottom).offset(-10)
        }

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
        
        let Info = ContactInfo(name: nameTextField.text!, phoneNumber: phoneNumberTextField.text!, companyName: companyNameTextField.text!, email: emailTextField.text!)
        var qrCodeContents = QRCode(Info.exchangeToQRString())
        qrCodeContents?.color = CIColor(color: UIColor.blueColor())
        qrImage.image=qrCodeContents?.image
    }
    
    func filteredUIimageConvert(image: UIImage)->UIImage
    {
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        let convertibleImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return convertibleImage
    }
    
    func saveQRCode(button: UIButton){
        if let image = qrImage.image{
            UIImageWriteToSavedPhotosAlbum(filteredUIimageConvert(image), self, #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }else{
            showAlert("QRCode Image is Empty!")
        }
    }
    
    func resetView() {
        qrImage.image = nil
        nameTextField.text=nil
        phoneNumberTextField.text=nil
        companyNameTextField.text=nil
        emailTextField.text=nil
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(UIAlertAction) in
                self.resetView()
            }))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, message: String? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}

