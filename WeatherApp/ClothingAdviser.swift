//
//  ClothingAdviser.swift
//  WeatherApp
//
//  Created by August Posner on 2018-04-06.
//  Copyright © 2018 August Posner. All rights reserved.
//

import Foundation

struct ClothingAdviser {
    private func heatAdvice(temp: Double) -> String {
        if temp < 0 {
            return "Put on a warm jacket, a hat and gloves."
        } else if temp >= 0 && temp < 15 {
            return "Put on a lighter jacket and leave the shorts at home."
        } else {
            return "Shirt and shorts will keep you warm enough."
        }
    }
    
    private func rainAdvice(weatherID: Int) -> String {
        switch weatherID {
        case 800:
            return "Sunglasses might come in handy. At least during daytime."
        case 801...804:
            return "Small risk for rain. Bring an umbrella if you want to play it safe."
        case 300...321:
            return "Bring an umbrella and a poncho."
        case 500...531:
            return "Bring everything you can find that will keep you dry."
        case 200...232:
            return "But preferably stay inside."
        case 600...622:
            return "Dress for a day in the snow."
        default:
            return ""
        }
    }
    
    func recommend(weather: WeatherData) -> String {
        return heatAdvice(temp: weather.temp) + " " + rainAdvice(weatherID: weather.weatherID)
    }
}
