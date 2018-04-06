//
//  GraphController.swift
//  WeatherApp
//
//  Created by August Posner on 2018-04-04.
//  Copyright © 2018 August Posner. All rights reserved.
//

import UIKit
import GraphKit

class GraphController: UIViewController, GKBarGraphDataSource {
    
    @IBOutlet weak var diagram: GKBarGraph!
    var cityIDs: [Int] = []
    let weather = WeatherGetter()
    var weatherList: [WeatherData] = []
    let screenSize = UIScreen.main.bounds
    let barColors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow]
    
    func numberOfBars() -> Int {
        return weatherList.count
    }
    
    func valueForBar(at index: Int) -> NSNumber! {
        return weatherList[index].temp + 15 as NSNumber
    }
    
    func titleForBar(at index: Int) -> String! {
        return "\(weatherList[index].name!)"
    }
    
    func colorForBar(at index: Int) -> UIColor! {
        return barColors[index % barColors.count]
    }
    
    func setBarSizes() {
        let marginSums = diagram.marginBar * CGFloat(cityIDs.count)
        diagram.barWidth = (screenSize.width - marginSums) / CGFloat(cityIDs.count)
        diagram.barHeight = screenSize.height * 0.5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarSizes()
        fillWeatherList()
        diagram.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fillWeatherList() {
        for id in cityIDs {
            weather.getWeatherAsync(cityID: id) {
                (decodedInstance) in self.weatherList.append(decodedInstance!)
                self.diagram.draw()
            }
        }
    }
}
