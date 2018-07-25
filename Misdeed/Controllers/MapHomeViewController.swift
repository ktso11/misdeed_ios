//
//  MapHomeViewController.swift
//  Misdeed
//
//  Created by Katie YK So on 7/25/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapHomeViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    

    @IBOutlet var mapSearchBar: UISearchBar!
    @IBOutlet weak var MapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSearchBar.delegate = self
        MapView.showsUserLocation = true
        
    }

    func searchBarSearchButtonClicked (_ searchBar: UISearchBar){
        print("searchinggg....", mapSearchBar.text ?? "nothing entered yet")
    }
    


    
    
}

