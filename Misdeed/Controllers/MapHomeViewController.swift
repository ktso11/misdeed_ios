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

class MapHomeViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    

    @IBOutlet weak var showPoliceIncidentsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!


    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var regionRadius: CLLocationDistance = 7000
    var policeReports: [Place] = []
    var resultSearchController:UISearchController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapSearchBar.delegate = self
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
//        var canShowCallout: Bool { get set }
        
        //search bar tutorial starts here...
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.mapView = mapView
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        //search bar tutorial ends here...
        
        
        Networking.getPoliceReports { (json) in
            
            let count = json.count
            for index in 0 ... count - 1 {
                
                let title = json[index]["category"].stringValue
                let subtitle = json[index]["descript"].stringValue
                let date = json[index]["date"].stringValue
                let address = json[index]["address"].stringValue
                let x = json[index]["location"]["coordinates"][0].doubleValue
                let y = json[index]["location"]["coordinates"][1].doubleValue
                let coordinate = CLLocationCoordinate2D(latitude: y, longitude: x)
            
                let newReport = Place(title: title, subtitle: subtitle, date: date, address: address, coordinate: coordinate)
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
    
    //Setting Up Search Bar

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//        if locations.first != nil {
            print("location:: \(location)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }

    
    //Police Report API
    @IBAction func showPoliceIncidentsButtonTapped(_ sender: UIButton) {
        print("show api!")
        DispatchQueue.main.async {
            for x in 0 ... 3 {
                self.mapView.addAnnotation(self.policeReports[x])
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    func setUpMap(){
        startLocation = CLLocation(latitude: 37.72171, longitude: -122.426844)
        centerMapOnLocation(location: startLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapHomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = #imageLiteral(resourceName: "red-pin")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetailsSegue" {
//            let vc = segue.destination as! DetailViewController
//            vc.addressLabel.text =
//        }
//
//    }
  
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl ){
        if control == view.rightCalloutAccessoryView {
//            performSegue(withIdentifier: "showDetailsSegue", sender: self)
            
            
        }
        // create segue in storyboard
        // call prepare for segue in this method (refer to stackoverflow post
        // use the prepareforsegue method to pass on appropriate data

        let annView = view.annotation as! Place //???
        let storyboard = UIStoryboard(name: "MapHomeView", bundle: .main)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "details") as! DetailViewController
        detailViewController.address = annView.address
        detailViewController.date = annView.date
        detailViewController.descript = annView.title!
        detailViewController.category = annView.subtitle!
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

}
