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


class Place: NSObject, MKAnnotation {
//    let category: String
//    let descript: String
//    let date: String
//    let address: String
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
//    init(category: String, descript: String, date: String, address: String, coordinate: CLLocationCoordinate2D) {
//        self.category = category
//        self.descript = descript
//        self.date = date
//        self.address = address
//        self.coordinate = coordinate
//    }
    
}


//self.category = json["category"].stringValue
//self.description = json["descript"].stringValue
//self.date = json["date"].stringValue
//self.address = json["address"].stringValue
