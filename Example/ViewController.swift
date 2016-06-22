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
    
    let qrCodeName = QRCode("Anthony Kim")
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImage.image = qrCodeName?.image
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

