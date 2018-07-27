//
//  MapHomeViewController.swift
//  Misdeed
//
//  Created by Katie YK So on 7/25/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class MapHomeViewController: UIViewController, UISearchBarDelegate {
    

    @IBOutlet weak var showPoliceIncidentsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var mapSearchBar: UISearchBar!

    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var regionRadius: CLLocationDistance = 7000
    var policeReports: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSearchBar.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        Networking.getPoliceReports { (json) in
            
            let count = json.count
            for index in 0 ... count - 1 {
                
                let title = json[index]["category"].stringValue
                let subtitle = json[index]["descript"].stringValue
                let x = json[index]["location"]["coordinates"][0].doubleValue
                let y = json[index]["location"]["coordinates"][1].doubleValue
                let coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
                
                let newReport = Place(title: title, subtitle: subtitle, coordinate: coordinate)
                self.policeReports.append(newReport)
//                let category = json[index]["category"].stringValue
//                let descriptiion = json[index]["descript"].stringValue
//                let date = json[index]["date"].stringValue
//                let address = json[index]["address"].stringValue
//                let x = json[index]["location"]["coordinates"][0].doubleValue
//                let y = json[index]["location"]["coordinates"][1].doubleValue
//                let coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
//                
//                let newReport = PoliceReport(category: category, descript: descriptiion, date: date, address: address, coordinate: coordinate)
//                self.policeReports.append(newReport)
            }
        }
//        requestLocationAccess()
        setUpMap()
    }
    
    

    @IBAction func showPoliceIncidentsButtonTapped(_ sender: UIButton) {
        print("show api!")
        DispatchQueue.main.async {

            for x in 0 ... 3 {
                self.mapView.addAnnotation(self.policeReports[x] as! MKAnnotation)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }

        
//        for reports in items["incidentReports"].arrayValue
//        {
//            print(reports)
//
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: reports["x"].doubleValue, longitude: reports["y"].doubleValue)
//            self.mapView.addAnnotation(annotation)
//        }
    }
    
    func setUpMap(){
        startLocation = CLLocation(latitude: 37.72171, longitude: -122.426844)
        centerMapOnLocation(location: startLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func searchBarSearchButtonClicked (_ searchBar: UISearchBar){
        print("searchinggg....", mapSearchBar.text ?? "nothing entered yet")
    }
}

extension MapHomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = #imageLiteral(resourceName: "greenpin")
            return annotationView
        }
    }
    
}
