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
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    var city: String?
    let weather = WeatherGetter()
    let dbHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        favoriteSwitch.isOn = dbHelper.isSaved(city!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteSwitched(_ sender: Any) {
        if favoriteSwitch.isOn {
            dbHelper.add(city: city!)
        } else {
            dbHelper.delete(city: city!)
        }
    }
    
    
    func setText() {
        let weatherInfo = weather.getWeather(city: city!)
        let info = "\(weatherInfo.name) \n Temperature: \(weatherInfo.temp) C degrees \n Windspeed: \(weatherInfo.windSpeed) m/s \n Sun rises at: \(weatherInfo.sunUpString) \n Sun sets at: \n \(weatherInfo.sunDownString)  "
        infoLabel.text = info
    }
    

}