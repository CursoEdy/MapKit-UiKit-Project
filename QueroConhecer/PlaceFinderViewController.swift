//
//  PlaceFinderViewController.swift
//  QueroConhecer
//
//  Created by ednardo alves on 08/12/24.
//

import UIKit
import MapKit

class PlaceFinderViewController: UIViewController {
    
    @IBOutlet weak var localText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView!
    

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
            
            guard let placemark = placemarks?.first else {return}
            print(Place.getFormattedAdress(with: placemark))
        }
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
