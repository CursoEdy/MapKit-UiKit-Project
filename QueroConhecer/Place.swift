//
//  Place.swift
//  QueroConhecer
//
//  Created by ednardo alves on 09/12/24.
//

import Foundation
import MapKit

struct Place: Codable, Hashable {
    let id: Int
    let name: String
    let adress: String
    
    //necessário importar MapKit
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAdress(with placemark: CLPlacemark) -> String {
        var adress = ""
        
        if let street = placemark.subThoroughfare {
            adress += street // ++ Logradouro
        }
        if let number = placemark.thoroughfare {
            adress += "nº \(number), " // ++ Número
        }
        if let subLocality = placemark.subLocality {
            adress += "\(subLocality)\n" // ++ Bairro
        }
        if let city = placemark.locality {
            adress += "\(city)" // ++ Cidade
        }
        if let neighborhood = placemark.administrativeArea {
            adress += "\(neighborhood)\n" // ++ Estado
        }
        if let postalCode = placemark.postalCode {
            adress += "\(postalCode)\n" // ++ CEP
        }
        if let country = placemark.country {
            adress += "\(country)" // ++ Pais
        }
        
        return adress
    }
    
}
