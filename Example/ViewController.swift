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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


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
    var originValue: CGFloat = 0.0
    
    enum InputError: Error{
        case noName
        case noPhoneNumber
        case noCompanyName
        case noEmail
        case outOfRange
        case nameTooLong
        case companyNameTooLong
        case emailTooLong
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContentsConstrant()
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        companyNameTextField.delegate = self
        emailTextField.delegate = self
        originValue = self.view.frame.origin.y
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        adjustingHeight(true, notification: notification)
        
    }
    
    func keyboardWillHide(_ notification:Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    func adjustingHeight(_ show:Bool, notification:Notification) {
        if show{
            if originValue == self.view.frame.origin.y{
                self.view.frame.origin.y -= 200
            }
        }else {
            self.view.frame.origin.y += 200

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setContentsConstrant(){
        let superView = self.view
        let borderWidth: CGFloat = 0.5
        let cornerRadius: CGFloat = 5.0
        
        superView?.addSubview(qrImage)
        superView?.addSubview(inputContentsView)
        inputContentsView.addSubview(nameTextField)
        inputContentsView.addSubview(nameLabel)
        inputContentsView.addSubview(phoneNumberTextField)
        inputContentsView.addSubview(phoneNumberLabel)
        inputContentsView.addSubview(companyNameTextField)
        inputContentsView.addSubview(companyNameLabel)
        inputContentsView.addSubview(emailTextField)
        inputContentsView.addSubview(emailLabel)
        superView?.addSubview(generatingButton)
        superView?.addSubview(saveButton)
        
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
        
        qrImage.layer.borderColor = UIColor.black.cgColor
        qrImage.layer.borderWidth = borderWidth
        qrImage.backgroundColor = UIColor.white
        qrImage.snp_makeConstraints { (make) in
            make.top.equalTo(superView!.snp_top).offset(90)
            make.size.equalTo(150*UIScreen.main.bounds.height/500)
            make.centerX.equalTo(superView!.snp_centerX)
        }
        
        inputContentsView.backgroundColor = UIColor.white
        inputContentsView.snp_makeConstraints { (make) in
            make.top.equalTo(qrImage.snp_bottom).offset(35)
            make.leading.equalTo(superView!.snp_leading).offset(10)
            make.trailing.equalTo(superView!.snp_trailing).offset(-10)
            make.bottom.equalTo(superView!.snp_bottom).offset(-60)
            make.centerX.equalTo(superView!.snp_centerX)
        }
        
        nameLabel.text = "Name"
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(inputContentsView.snp_top).offset(5)
            make.leading.equalTo(inputContentsView.snp_leading).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(phoneNumberLabel.snp_height)
        }
        
        nameTextField.borderStyle = .roundedRect
        nameTextField.backgroundColor = UIColor.clear
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
        
        phoneNumberTextField.borderStyle = .roundedRect
        phoneNumberTextField.backgroundColor = UIColor.clear
        phoneNumberTextField.keyboardType = .numberPad
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
        
        companyNameTextField.borderStyle = .roundedRect
        companyNameTextField.backgroundColor = UIColor.clear
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
        
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp_makeConstraints { (make) in
            make.top.equalTo(companyNameTextField.snp_bottom).offset(3)
            make.leading.equalTo(emailLabel.snp_trailing).offset(10)
            make.trailing.equalTo(inputContentsView.snp_trailing).offset(-3)
            make.bottom.equalTo(inputContentsView.snp_bottom).offset(-5)
        }
        
        generatingButton.backgroundColor = UIColor.white
        generatingButton.layer.borderWidth = borderWidth
        generatingButton.layer.borderColor = UIColor.black.cgColor
        generatingButton.layer.cornerRadius = cornerRadius
        generatingButton.setTitle("MAKE", for: UIControlState())
        generatingButton.setTitleColor(UIColor.black, for: UIControlState())
        generatingButton.addTarget(self, action: #selector(generatingQRCode), for: .touchUpInside)
        generatingButton.snp_makeConstraints { (make) in
            make.trailing.equalTo(superView!.snp_centerX).offset(-5)
            make.bottom.equalTo(superView!.snp_bottom).offset(-10)
        }
        
        saveButton.layer.borderWidth = borderWidth
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.layer.cornerRadius = cornerRadius
        saveButton.backgroundColor = UIColor.white
        saveButton.setTitle("SAVE", for: UIControlState())
        saveButton.setTitleColor(UIColor.black, for: UIControlState())
        saveButton.addTarget(self, action: #selector(saveQRCode), for: .touchUpInside)
        saveButton.snp_makeConstraints { (make) in
            make.leading.equalTo(superView!.snp_centerX).offset(5)
            make.bottom.equalTo(superView!.snp_bottom).offset(-10)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func generatingQRCode(_ button: UIButton) {
        do{
            try generatingQRcode()
        }catch InputError.noName{
            showAlert("Your name space is empty")
        }catch InputError.nameTooLong{
            showAlert("Name's length is Too Long")
        }catch InputError.noPhoneNumber{
            showAlert("Your PhoneNumber space is empty")
        }catch InputError.outOfRange{
            showAlert("PhoneNumber's length is Out Of Range")
        }catch InputError.noCompanyName{
            showAlert("Your CompanyName space is empty")
        }catch InputError.companyNameTooLong{
            showAlert("CompanyName's length is Too Long")
        }catch InputError.noEmail{
            showAlert("Your Email space is empty")
        }catch InputError.emailTooLong{
            showAlert("Email's length is Too Long")
        }
        catch {
            showAlert("Exceptional Error!")
        }
    }
    
    func generatingQRcode() throws{
        
        guard nameTextField.text?.isEmpty == false else {
            throw InputError.noName
        }
        
        guard nameTextField.text?.characters.count < 31 else {
            throw InputError.nameTooLong
        }
        
        guard phoneNumberTextField.text?.isEmpty == false else {
            throw InputError.noPhoneNumber
        }
        
        guard phoneNumberTextField.text?.characters.count < 12 else {
            throw InputError.outOfRange
        }
        
        guard companyNameTextField.text?.isEmpty == false else {
            throw InputError.noCompanyName
        }
        
        guard companyNameTextField.text?.characters.count < 31 else {
            throw InputError.companyNameTooLong
        }
        
        guard emailTextField.text?.isEmpty == false else {
            throw InputError.noEmail
        }

        guard emailTextField.text?.characters.count < 31 else {
            throw InputError.emailTooLong
        }
        
        let Info = ContactInfo(name: nameTextField.text!, phoneNumber: phoneNumberTextField.text!, companyName: companyNameTextField.text!, email: emailTextField.text!)
        if let qrCodeContents = QRCode(Info.exchangeToQRString()){
            qrImage.image=qrCodeContents.image
        }else{
            showAlert("Error on QRCode converting!")
        }
    }
    
    func filteredUIimageConvert(_ image: UIImage)->UIImage
    {
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let convertibleImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return convertibleImage!
    }
    
    func saveQRCode(_ button: UIButton){
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
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(UIAlertAction) in
                self.resetView()
            }))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    func showAlert(_ title: String, message: String? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

