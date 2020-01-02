//
//  AddLocationViewController.swift
//  PickDesireLocation
//
//  Created by Ali Raza Amjad on 02/01/2020.
//  Copyright © 2020 Ali Raza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblCountryName: UILabel!
    
    var locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationMangerSettings()
    }
    
    private func locationMangerSettings() {
        //MAP Settings
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    private func setPinOnMapView() {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = self.latitude
        annotation.coordinate.longitude = self.longitude
        
        self.mapView.addAnnotation(annotation)
        
        self.setCityName()
    }
    
    @IBAction func addPin(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        
        let locValue = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locValue
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
        
        self.setCityName()
    }
    
    private func setCityName() {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            if placemarks != nil {
                placeMark = placemarks?[0]

                // Country
                if let country = placeMark.country {
                    self.lblCountryName.text = country
                }
                // City
                if let city = placeMark.locality {
                    self.lblCountryName.text = self.lblCountryName.text! + " " + city
                }
                
                //
                if let name = placeMark.name {
                    self.lblCountryName.text = self.lblCountryName.text! + " " + name
                }
            }
        })
    }
    
    //MARK: CLLocationManageDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue = manager.location!.coordinate
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: locValue, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        self.setPinOnMapView()
    }
}

