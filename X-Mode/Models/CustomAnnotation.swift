//
//  CustomAnnotation.swift
//  X-Mode
//
//  Created by Green, Jonathan on 7/17/18.
//  Copyright © 2018 Green, Jonathan. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    var locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
