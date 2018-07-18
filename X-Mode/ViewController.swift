//
//  ViewController.swift
//  X-Mode
//
//  Created by Green, Jonathan on 7/16/18.
//  Copyright © 2018 Green, Jonathan. All rights reserved.
//

import UIKit
import MapKit
import SwiftWebSocket

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,InteracterDelegate {
    
    var locationManager: CLLocationManager?
    let regionRadius: CLLocationDistance = 100000
    var mapView:MKMapView?
    var interacter = Interacter()
    var id = NSUUID().uuidString
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView(frame: self.view.frame)
        self.view.addSubview(mapView ?? MKMapView())
        mapView?.mapType = .hybrid
        mapView?.showsCompass = true
        mapView?.showsScale = true
        mapView?.showsUserLocation = true
        mapView?.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        interacter.delegate = self
        interacter.doSomeWork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(user:UserLocation) {
        self.getAddess(latitude: Double(user.lat ?? "") ?? 0, longitude: Double(user.long ?? "") ?? 0, completion: { (address, annotation) in
            if user.id != self.id {
                let currentAnnotation = annotation
                currentAnnotation.locationName = user.id ?? ""
                let annotations = self.mapView?.annotations
                for object in annotations! {
                    let customObject = object as? CustomAnnotation
                    if customObject?.locationName == currentAnnotation.locationName {
                        self.mapView?.removeAnnotation(customObject!)
                        
                    }
                }
                let annotationView = MKMarkerAnnotationView(annotation: currentAnnotation, reuseIdentifier: "marker")
                self.mapView?.addAnnotation(annotationView.annotation!)
            }
        })
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // you're good to go!
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let last = locations.last ?? CLLocation()
        //centerMapOnLocation(location:last)
        var userLocation = UserLocation()
        userLocation.id = id
        userLocation.lat = "\(last.coordinate.latitude)"
        userLocation.long = "\(last.coordinate.longitude)"
        interacter.client.sock?.send(Data().toString(data: userLocation.encode()))
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        guard let annotation = annotation as? CustomAnnotation else {return nil}
        let identifier = "marker"
        let color = UIColor.blue
        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.markerTintColor = color
        annotationView.glyphTintColor = .yellow
        //annotationView.clusteringIdentifier = identifier
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let lat =  mapView.userLocation.coordinate.latitude
        let long = mapView.userLocation.coordinate.longitude
        getAddess(latitude: lat, longitude: long) { address, annotation in
            self.mapView?.userLocation.title = address
        }
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }
    
    func getAddess(latitude: Double, longitude: Double,completion:@escaping (_ address:String,_ annotation:CustomAnnotation) -> Void) {
        geocode(latitude: latitude, longitude: longitude) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            // you should always update your UI in the main thread
            DispatchQueue.main.async {
                let streetNumber = placemark.subThoroughfare ?? ""
                let address = placemark.thoroughfare ?? ""
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let fullAddress = "\(streetNumber) \(address) \(city) \(state)"
                let coords = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = CustomAnnotation(title: fullAddress, locationName: "", discipline: "", coordinate: coords)
                completion(fullAddress, annotation)
            }
        }
    }
}






