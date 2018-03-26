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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityIDs = dbHelper.load()
        
        navigationItem.leftBarButtonItem = editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cityIDs = dbHelper.load()
        tableView.reloadData()
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        weatherGetter.getWeatherAsync(cityID: cityIDs[indexPath.row]) {
            (decodedInstance) in self.weather = decodedInstance
            
            if let weather = self.weather {
                cell.cityLabel?.text = weather.name
                cell.tempLabel?.text = "\(weather.tempString) C degrees"
            }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let selectedRow = indexPath.row
            let destination = segue.destination as! DetailController
            destination.cityID = cityIDs[selectedRow]
        }
    }
    

}
