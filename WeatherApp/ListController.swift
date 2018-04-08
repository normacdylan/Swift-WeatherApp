//
//  ListController.swift
//  WeatherApp
//
//  Created by August Posner on 2018-03-02.
//  Copyright © 2018 August Posner. All rights reserved.
//

import UIKit

class ListController: UITableViewController {
    
    let dbHelper = DBHelper()
    let weatherGetter = WeatherGetter()
    var cityIDs: [Int] = []
    var weather: WeatherData?
    var selectedCityIDs: [Int] = []
    
    @IBOutlet weak var graphButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityIDs = dbHelper.load()
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cityIDs = dbHelper.load()
        tableView.reloadData()
        graphButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityIDs.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        weatherGetter.getWeatherAsync(cityID: cityIDs[indexPath.row]) {
            (decodedInstance) in self.weather = decodedInstance
            
            if let weather = self.weather {
                cell.cityLabel?.text = weather.name! + ", " + weather.country
                cell.tempLabel?.text = "\(weather.tempString) C degrees"
                cell.weatherImage?.image = UIImage(data: weather.iconImageData!)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            performSegue(withIdentifier: "detailSegue", sender: nil)
        } else {
            if let selected = tableView.indexPathsForSelectedRows {
                selectedCityIDs = selected.map{cityIDs[$0.row]}
                graphButton.isEnabled = selected.count > 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selected = tableView.indexPathsForSelectedRows {
            selectedCityIDs = selected.map{cityIDs[$0.row]}
            graphButton.isEnabled = selected.count > 1
        }
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityID = cityIDs[indexPath.row]
            cityIDs.remove(at: indexPath.row)
            dbHelper.delete(cityID: cityID)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            
            if segue.identifier == "detailSegue" {
                let destination = segue.destination as! DetailController
                destination.cityID = cityIDs[selectedRow]
            }
        }
        
        if segue.identifier == "graphSegue" {
            let destination = segue.destination as! GraphController
            destination.cityIDs = selectedCityIDs
        }
    }
}
