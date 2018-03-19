//
//  DetailController.swift
//  WeatherApp
//
//  Created by August Posner on 2018-03-15.
//  Copyright © 2018 August Posner. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    
    var city: String?
    let weather = WeatherGetter()
    let dbHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        saveButton.isEnabled = !dbHelper.isSaved(city!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func pressedSave(_ sender: Any) {
        dbHelper.add(city: city!)
        saveButton.isEnabled = !dbHelper.isSaved(city!)
    }
   
    func setText() {
        let weatherInfo = weather.getWeather(city: city!)
        nameLabel.text = weatherInfo.name
        let info = "Temperature: \(weatherInfo.tempString) C degrees \nWindspeed: \(weatherInfo.windSpeed) m/s \nSun rises at: \(weatherInfo.sunUpString) \nSun sets at: \(weatherInfo.sunDownString)"
        infoLabel.text = info
    }
    

}
