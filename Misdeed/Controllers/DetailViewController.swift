//
//  DetailViewController.swift
//  Misdeed
//
//  Created by Katie YK So on 7/30/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var address = ""
    var date = ""
    var descript = ""
    var category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = address
        dateLabel.text = date
        descriptionLabel.text = descript
        categoryLabel.text = category
    }
}
