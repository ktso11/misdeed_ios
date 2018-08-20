//
//  Networking.swift
//  Misdeed
//
//  Created by Katie YK So on 7/26/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FirebaseDatabase

class Networking {

    
    static func getPoliceReports(completion: @escaping(JSON) -> ()) {
//        var reports: JSON = nil
        let policereports = "https://data.sfgov.org/resource/cuks-n6tp.json"
        Alamofire.request(policereports).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let reports = JSON(value)
                    completion(reports)
                }
            case .failure(let error):
                print(error)
            }
        }
        ;
    }
    
//    static func getUserReports(for report: Report, completion: @escaping ([Reports]) -> Void) {
//        let ref = Database.database().reference().child("userReports")
//        
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let snapshot = snapshot.child.allObjects as? [DataSnapshot] else {
//                return completion([])
//            }
//            let posts = snapshot.reversed().compactMap(Reports.init)
//            completion(report)
//            })
//    }
}
