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
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var adviceLabel: UILabel!
    
    var dynamicAnimator: UIDynamicAnimator!
    var push : UIPushBehavior!
    var cityID: Int?
    let weather = WeatherGetter()
    let dbHelper = DBHelper()
    let adviser = ClothingAdviser()
    var weatherInfo: WeatherData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        iconImage.isUserInteractionEnabled = true
        dynamicAnimator = UIDynamicAnimator(referenceView: iconImage)
        push = UIPushBehavior(items: [iconImage], mode: .instantaneous)
        dynamicAnimator.addBehavior(push)
        saveButton.isEnabled = !dbHelper.isSaved(cityID!)
        animateIcon()
        pushIcon()
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
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
        //    self.iconImage.center = CGPoint(x: 300, y: 400)
            self.iconImage.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        })
    }
    
    func pushIcon() {
        push = UIPushBehavior(items: [iconImage], mode: .continuous)
        push.pushDirection = CGVector(dx: 1, dy: 0)
        push.magnitude = 0.05
        dynamicAnimator.addBehavior(push)
    }
    
    func setViews() {
        weather.getWeatherAsync(cityID: cityID!) {
            (decodedInstance) in self.weatherInfo = decodedInstance
            if let info = self.weatherInfo {
                self.title = info.name! + ", " + info.country
                let infoText = "Temperature: \(info.tempString) C degrees \nWindspeed: \(info.windSpeed) m/s \nSun rises at: \(info.sunUpString) \nSun sets at: \(info.sunDownString)"
                self.infoLabel.text = infoText
                self.iconImage.image = UIImage(data: info.iconImageData!)
                self.adviceLabel.text = self.adviser.recommend(weather: info)
            }
        }
    }
}
