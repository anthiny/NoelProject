//
//  DetailViewController.swift
//  Example
//
//  Created by Anthony Kim n on 2016. 6. 28..
//  Copyright © 2016년 Anthony Kim n. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var nameInfoLabel = UILabel()
    var nameLabel = UILabel()
    var phoneNumberInfoLabel = UILabel()
    var phoneNumberLabel = UILabel()
    var companyNameInfoLabel = UILabel()
    var companyNameLabel = UILabel()
    var emailInfoLabel = UILabel()
    var emailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContentsConstrant()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setContentsConstrant(){
        let superView = self.view
        
        superView.addSubview(nameInfoLabel)
        superView.addSubview(nameLabel)
        superView.addSubview(phoneNumberInfoLabel)
        superView.addSubview(phoneNumberLabel)
        superView.addSubview(companyNameInfoLabel)
        superView.addSubview(companyNameLabel)
        superView.addSubview(emailInfoLabel)
        superView.addSubview(emailLabel)
        
        nameInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        nameLabel.text = "Name"
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(superView.snp_top).offset(30)
            make.leading.equalTo(superView.snp_leading).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(phoneNumberLabel.snp_height)
        }
        
        phoneNumberLabel.text = "Phone"
        phoneNumberLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom).offset(12)
            make.leading.equalTo(superView.snp_leading).offset(10)
            make.width.equalTo(nameLabel.snp_width)
            make.height.equalTo(companyNameLabel.snp_height)
        }
        
        companyNameLabel.text = "Company"
        companyNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(phoneNumberLabel.snp_bottom).offset(12)
            make.leading.equalTo(superView.snp_leading).offset(10)
            make.width.equalTo(phoneNumberLabel.snp_width)
            make.height.equalTo(emailLabel.snp_height)
        }
        
        emailLabel.text = "Email"
        emailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(companyNameLabel.snp_bottom).offset(12)
            make.leading.equalTo(superView.snp_leading).offset(10)
            make.width.equalTo(companyNameLabel.snp_width)
            make.bottom.equalTo(superView.snp_bottom).offset(-30)
        }
        
        nameInfoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(superView.snp_top).offset(30)
            make.leading.equalTo(nameLabel.snp_trailing).offset(20)
            make.trailing.equalTo(superView.snp_trailing).offset(-10)
            make.height.equalTo(phoneNumberInfoLabel.snp_height)
        }
        
        phoneNumberInfoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameInfoLabel.snp_bottom).offset(12)
            make.leading.equalTo(phoneNumberLabel.snp_trailing).offset(20)
            make.trailing.equalTo(superView.snp_trailing).offset(-10)
            make.height.equalTo(companyNameInfoLabel.snp_height)
        }
        
        companyNameInfoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(phoneNumberInfoLabel.snp_bottom).offset(12)
            make.leading.equalTo(companyNameLabel.snp_trailing).offset(20)
            make.trailing.equalTo(superView.snp_trailing).offset(-10)
            make.height.equalTo(emailInfoLabel.snp_height)
        }
        
        emailInfoLabel.snp_makeConstraints { (make) in
            make.top.equalTo(companyNameInfoLabel.snp_bottom).offset(12)
            make.leading.equalTo(emailLabel.snp_trailing).offset(20)
            make.trailing.equalTo(superView.snp_trailing).offset(-10)
            make.bottom.equalTo(superView.snp_bottom).offset(-30)
        }

        
    }
    
}
