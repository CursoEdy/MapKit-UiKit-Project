//
//  PlaceAnotation.swift
//  QueroConhecer
//
//  Created by ednardo alves on 12/12/24.
//

import Foundation
import MapKit

class PlaceAnotation: NSObject, MKAnnotation {
    
    enum PlaceType {
        case place
        case poi
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var type: PlaceType
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, type: PlaceType) {
        self.coordinate = coordinate
        self.type = type
    }
    
}
