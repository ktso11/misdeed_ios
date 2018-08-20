//
//  MapHomeViewController.swift
//  Misdeed
//
//  Created by Katie YK So on 7/25/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MapKit
import FirebaseDatabase

class MapHomeViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var addIncidentReportViewButton: UIButton!
    @IBOutlet weak var showPoliceIncidentsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showUserReportsButton: UIButton!
    
    // MARK: - Properties
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var regionRadius: CLLocationDistance = 7000
    var policeReports: [Place] = []
    var resultSearchController:UISearchController? = nil
//    var ref:DatabaseReference?
    var userReports: [UserReports] = []
    
    // MARK: - View Lifecycle Methods
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
            }
        }
        setUpMap()
        fetchReports()
     
    
    }
    
    //Setting Up Search Bar

    // MARK: - Methods
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

    
    func fetchReports() {
        let reportRef = Database.database().reference().child("userReports")
        reportRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapShots = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for snapshot in snapShots {
                // Looping through the array of snapshots and converting each snapshot into a report
                guard let report = UserReports(snapshot: snapshot) else {
                    return assertionFailure("Failed to use snapshot")
                }
                // After converting snapshots into reports, append the reports into userReports array
                self.userReports.append(report)
            }
            print("Reports: \(self.userReports.count) found")
        }
    }
    
    // MARK: - IBActions
    @IBAction func showUserReportsTapped(_ sender: Any) {
        print("adrress is \(userReports[1].address)")
        let dg = DispatchGroup()
            for report in self.userReports {
                dg.enter()
                 let location = report.address
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(location) {
                    placemarks, error in
                    let placemark = placemarks?.first
                    let lat = placemark?.location?.coordinate.latitude
                    let lon = placemark?.location?.coordinate.longitude
                    report.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
              dg.leave()
                }
                dg.notify(queue: .main) {
                     self.mapView.addAnnotations(self.userReports)
                }
            }
    }
    
    //Police Report API
    @IBAction func showPoliceIncidentsButtonTapped(_ sender: UIButton) {
        print("show api!")
        let allReports = policeReports.count
//        allReports = allReports.sorted(by: {$0.date.compare($1.date) == .orderedDescending

        let sortedReport = policeReports.sorted(by: {$0.dateInterval! > $1.dateInterval!})
        
        DispatchQueue.main.async {
            for report in self.policeReports {
             
                if report.dateInterval! <= 90 {
                     self.mapView.addAnnotations(self.policeReports)
                }
                
                
               
//                self.mapView.addAnnotation(self.policeReports[x])
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
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = #imageLiteral(resourceName: "red-pin")
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl ){
        if control == view.rightCalloutAccessoryView {
        }
        
        if let annView = view.annotation as? Place  {

            let storyboard = UIStoryboard(name: "MapHomeView", bundle: .main)
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "details") as! DetailViewController
            detailViewController.address = annView.address
            detailViewController.date = annView.date
            detailViewController.descript = annView.title!
            detailViewController.category = annView.subtitle!
           
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else if let annView = view.annotation as? UserReports {
            
            let storyboard = UIStoryboard(name: "MapHomeView", bundle: .main)
            let detailViewController = storyboard.instantiateViewController(withIdentifier: "details") as! DetailViewController
            detailViewController.address = annView.address
            detailViewController.date = annView.date
            detailViewController.descript = annView.descript
            detailViewController.category = annView.category!
            
            self.navigationController?.pushViewController(detailViewController, animated: true)
            
            
        }
    }
}

extension String{
    func toDate() -> Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        return dateFormatter.date(from: self)
    }
}




