//
//  UserService.swift
//  Makestagram
//
//  Created by Katie YK So on 7/11/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth.FIRUser

struct UserService{
    static func show(forUID uid: String, completion: @escaping (User?) -> Void ){
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    }
    
    static func create(_ firuser: FIRUser, username: String, completion: @escaping (User?)-> Void) {
        let userAttrs = ["username": username]
        let ref = Database.database().reference().child("users").child(firuser.uid)
        //        Database.database().reference().child("companies").child(firuser.uid)
        ref.setValue(userAttrs) {(error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
}
