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
    let date: String
    let address: String
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    var dateInterval: Int?
    
    init(title: String, subtitle: String, date: String, address: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
                self.date = date
                self.address = address
        
        super.init()
        
        self.dateInterval = datePassed()
    }
  
    
     private func datePassed() -> Int?{
        let stringdate = self.date
        let slicedDate = stringdate.components(separatedBy: "T")
        let cleanStringDate = slicedDate.first
        let date = cleanStringDate?.toDate()
        let interval = Calendar.current.dateComponents([.day], from: date!, to: Date()).day
        return interval
    }
}


