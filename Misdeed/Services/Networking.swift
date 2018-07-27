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

class Networking {
    
    static func getPoliceReports(completion: @escaping(JSON) -> ()) {
        var reports: JSON = nil
        let policereports = "https://data.sfgov.org/resource/cuks-n6tp.json"
        Alamofire.request(policereports).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    reports = JSON(value)
                    completion(reports)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
