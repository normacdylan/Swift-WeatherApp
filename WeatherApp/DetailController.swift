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
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var adviceLabel: UILabel!
    
    var dynamicAnimator: UIDynamicAnimator!
    var snap : UISnapBehavior!
    
    var cityID: Int?
    let weather = WeatherGetter()
    let dbHelper = DBHelper()
    let adviser = ClothingAdviser()
    var weatherInfo: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        dynamicAnimator = UIDynamicAnimator(referenceView: iconImage)
        snap = UISnapBehavior(item: iconImage, snapTo: CGPoint(x: 200, y: 500))
  //      dynamicAnimator.addBehavior(snap)
        saveButton.isEnabled = !dbHelper.isSaved(cityID!)
        animateIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func pressedSave(_ sender: Any) {
        dbHelper.add(cityID: cityID!)
        saveButton.isEnabled = !dbHelper.isSaved(cityID!)
    }
    
    func animateIcon() {
        UIView.animate(withDuration: 5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.iconImage.center = CGPoint(x: 300, y: 400)
        })
    }
   
    func setViews() {
        weather.getWeatherAsync(cityID: cityID!) {
            (decodedInstance) in self.weatherInfo = decodedInstance
            if let info = self.weatherInfo {
                self.title = info.name!
                self.nameLabel.text = info.name! + ", " + info.country
                let infoText = "Temperature: \(info.tempString) C degrees \nWindspeed: \(info.windSpeed) m/s \nSun rises at: \(info.sunUpString) \nSun sets at: \(info.sunDownString)"
                self.infoLabel.text = infoText
                self.iconImage.image = UIImage(data: info.iconImageData!)
                self.adviceLabel.text = self.adviser.recommend(weather: info)
            }
        }
    }
}
