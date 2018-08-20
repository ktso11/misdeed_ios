//
//  PoliceReports.swift
//  Misdeed
//
//  Created by Katie YK So on 7/26/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit
import FirebaseDatabase.FIRDataSnapshot

class UserReports: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let date: String
    let address: String
    let category: String?
    var descript: String
    let id: String?
    var title: String?
    
    
    init(category: String, description: String, date: String, address: String, id: String, coordinate: CLLocationCoordinate2D) {
        self.category = category
        self.descript = description
        self.date = date
        self.address = address
        self.id = id
        self.coordinate = coordinate
        self.title = category
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let category = dict["category"] as? String,
            let description = dict["description"] as? String,
            let address = dict["address"] as? String,
            let date = dict["date"] as? String
            else { return nil }
        
        self.id = snapshot.key
        self.category = category
        self.descript = description
        self.address = address
        self.date = date
        self.title = category
        self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
}


