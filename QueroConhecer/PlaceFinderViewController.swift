//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by ednardo alves on 08/12/24.
//

import UIKit
import MapKit

class PlaceFinderViewController: UIViewController {
    
    enum PlaceFinderMessageType {
        case error(String)
        case confirmation(String)
    }
    
    @IBOutlet weak var localText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView!
    
    var place: Place!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func findLocal(_ sender: Any) {
        
        // Baixar teclado após digitacao/return
        localText.resignFirstResponder()
        let local = localText.text ?? ""
        load(show: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(local) { (placemarks, error) in
            self.load(show: false)
            if error == nil {
                if !self.savePlace(with: placemarks?.first) {
                    self.showMessage(tipo: .error("Erro ao localizar local"))
                }
            } else {
                self.showMessage(tipo: .error("Erro desconhecido"))
            }
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) ->  Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else { return false }
    
        let name  = placemark.name ?? placemark.country ?? "Desconhecido"
        let adress = Place.getFormattedAdress(with: placemark)
        
        place = Place(name: name, adress: adress, latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        //criando regiao
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        self.showMessage(tipo: .confirmation(place.name))
        
        return true
    }
    
    //criando alertas
    func showMessage(tipo: PlaceFinderMessageType) {
        let title: String
        let message: String
        var hasConfirmation: Bool = false
        
        switch tipo {
        case .error(let errorMsg):
            title = "Erro"
            message = errorMsg
        case .confirmation(let name):
            title = "Localizado"
            message = "Localizado com sucesso, deseja adicionar \(name)"
            hasConfirmation = true
        }
        
        //criando balao do alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "Adicionar", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(confirmAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //metodo auxiliar para exibir a tela de loading
    func load(show: Bool) {
        viewLoading.isHidden = !show
        if show {
            loading.startAnimating()
        }else {
            loading.stopAnimating()
        }
        
    }
    
    @IBAction func closeView(_ sender: Any) {
        //fecha a tela
        dismiss(animated: true, completion: nil)
    }
}
