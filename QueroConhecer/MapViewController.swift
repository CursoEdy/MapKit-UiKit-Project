//
//  MapViewController.swift
//  QueroConhecer
//
//  Created by ednardo alves on 08/12/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viInfo: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAdress: UILabel!
    @IBOutlet weak var loadingMap: UIActivityIndicatorView!
    
    var places: [Place]!
    var poi: [MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .mutedStandard
        searchBar.isHidden = true
        viInfo.isHidden = true
        
        mapView.delegate = self
        
        if places.count == 1 {
            title = places[0].name
        } else {
            title = "Meu lugares"
        }

        // Do any additional setup after loading the view.
        for place in places {
            addToMap(place)
        }
        
        showplaces()
    }
    
    func addToMap(_ place: Place) {
        //adicionando alfinetes em cada ponto salvo no map
        let annotation = PlaceAnotation(coordinate: place.coordinate, type: .place)
        annotation.title = place.name
        annotation.address = place.adress
        mapView.addAnnotation(annotation)
    }
    
    func showplaces() {
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    @IBAction func showRouter(_ sender: UIButton) {
    }
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        searchBar.resignFirstResponder()
        searchBar.isHidden = !searchBar.isHidden
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnotation) {
            return nil
        }
        let type = (annotation as! PlaceAnotation).type
        let identifier = "\(type)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.markerTintColor = .red
        }
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        annotationView?.markerTintColor = type == .place ? UIColor(.blue.opacity(0.5)) : UIColor(.red.opacity(0.5))
        annotationView?.glyphImage = type == .place ? UIImage(systemName: "airplane") : UIImage(systemName: "photo.artframe")
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        return annotationView
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        // resignFirstResponder() para recuar o teclado após a busca
        searchBar.resignFirstResponder()
        loadingMap.startAnimating()
        
        //criando a requisicao
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapView.region
        
        //criando o obj
        let search = MKLocalSearch(request: request)
        search.start {
            response,
            error in
            if error == nil {
                guard let response = response else {
                    self.loadingMap.stopAnimating()
                    return
                }
                self.mapView.removeAnnotations(self.poi)
                self.poi.removeAll()
                for item in response.mapItems {
                    let annotation = PlaceAnotation(coordinate: item.placemark.coordinate, type: .poi)
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    annotation.address = Place.getFormattedAdress(with: item.placemark)
                    self.poi.append(annotation)
                }
                self.mapView.addAnnotations(self.poi)
                self.mapView.showAnnotations(self.poi, animated: true)
            }
            self.loadingMap.stopAnimating()
        }
    }
}
