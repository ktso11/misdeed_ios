//
//  LoginViewController.swift
//  Misdeed
//
//  Created by Katie YK So on 7/31/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure("error signing in :\(error.localizedDescription)")
            return
        }

        guard let user = authDataResult?.user else { return }
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user)
                
                let storyboard = UIStoryboard(name: "MapHomeView", bundle: .main)
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            } else {
                // handle new user
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        }
    }
}
