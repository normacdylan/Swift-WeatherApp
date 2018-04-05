//
//  Weather.swift
//  WeatherApp
//
//  Created by August Posner on 2018-04-05.
//  Copyright © 2018 August Posner. All rights reserved.
//

import Foundation

struct WeatherList: Codable {
    let message: String
    let cod: String
    let count: Int
    let list: [WeatherData]
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}

struct WeatherData: Codable {
    let coord: [String : Double]?
    let weather: [Weather]?
    let base: String?
    let main: [String : Double]?
    let wind: [String : Double]?
    let clouds: [String : Double]?
    let rain: [String : Double]?
    let snow: [String : Double]?
    let dt: Date?
    let sys: Sys?
    let id: Int?
    let name: String?
    let cod: Int?
    
    //TODO: unwrappa variabler på rätt sätt
    
    var temp: Double {
        return main!["temp"]! - 273.15
    }
    
    var country: String {
        return sys!.country!
    }
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var cloudiness: Double {
        return clouds!["all"]!
    }
    
    var windSpeed: Double {
        return wind!["speed"]!
    }
    
    var sunUp: Date {
        let date = Date(timeIntervalSince1970: sys!.sunrise!)
        return date
    }
    
    var sunUpString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: sunUp)
    }
    
    var sunDown: Date {
        let date = Date(timeIntervalSince1970: sys!.sunset!)
        return date
    }
    
    var sunDownString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: sunDown)
    }
    
    var iconImageData: Data? {
        let url = URL(string:"http://openweathermap.org/img/w/\(weather![0].icon!).png")
        if let data = try? Data(contentsOf: url!) {
            return data
        }
        return nil
    }
}
