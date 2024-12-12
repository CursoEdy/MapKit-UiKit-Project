//
//  PlacesTableViewController.swift
//  QueroConhecer
//
//  Created by ednardo alves on 07/12/24.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    var places: [Place] = []
    let ud = UserDefaults.standard
    
    //exibir caso nao aja item na tabela
    var lbNoplaces: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlaces()
        
        //preparando label
        lbNoplaces = UILabel()
        lbNoplaces.text = "Não há localizações salvas"
        lbNoplaces.textColor = .lightGray
        lbNoplaces.numberOfLines = 0
        lbNoplaces.font = UIFont.systemFont(ofSize: 16)
        lbNoplaces.textAlignment = .center
        tableView.backgroundView = lbNoplaces
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! != "mapSegue" {
            let vc = segue.destination as! PlaceFinderViewController
            vc.delegate = self
        } else {
            let vc = segue.destination as! MapViewController
            switch sender {
                case let place as Place:
                    vc.places = [place]
                default:
                    vc.places = places
            }
        }
    }
    
    func loadPlaces(){
        if let placesData = ud.data(forKey: "places"){
            do {
                places = try JSONDecoder().decode([Place].self, from: placesData)
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func savePlaces(){
        let json = try? JSONEncoder().encode(places)
        ud.set(json, forKey: "places")
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    
    @objc func showAll() {
        performSegue(withIdentifier: "mapSegue", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if places.count > 0 {
            let btShowAll = UIBarButtonItem(title: "Mostrar Todos", style: .plain, target: self, action: #selector(showAll))
            navigationItem.leftBarButtonItem = btShowAll
            tableView.backgroundView = nil
        } else {
            // caso nao aja item na tabela
            navigationItem.leftBarButtonItem = nil
            tableView.backgroundView = lbNoplaces
        }
        
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        
        cell.textLabel?.text = place.name
        return cell
    }
    
    //metodo chamado sempre que o usuário seleciona uma tabela
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        performSegue(withIdentifier: "mapSegue", sender: place)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = places[indexPath.row]
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savePlaces()
            
        }
    }
}

extension PlacesTableViewController: PlaceFindeDelegate {
    func addPlace(_ place: Place) {
        if !places.contains(place) {
            places.append(place)
            savePlaces()
            tableView.reloadData()
        }
    }
}
