//
//  CreateUsernameViewController.swift
//  Misdeed
//
//  Created by Katie YK So on 8/1/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    // ...
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBAction func nextButtonTapped(_ sender: Any) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        
        
        UserService.create(firUser, username: username) { (user) in
            guard let _ = user else {
                return
            }
            
            let storyboard = UIStoryboard(name: "MapHomeView", bundle: .main)
            
            if let initialViewController = storyboard.instantiateInitialViewController() {
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 6
        
    }
}
