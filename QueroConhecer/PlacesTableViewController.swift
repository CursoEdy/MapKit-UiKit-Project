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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlaces()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! != "mapSegue" {
            let vc = segue.destination as! PlaceFinderViewController
            vc.delegate = self
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let place = places[indexPath.row]
        
        cell.textLabel?.text = place.name
        return cell
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
