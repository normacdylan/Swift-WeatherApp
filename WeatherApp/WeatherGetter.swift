//
//  WeatherGetter.swift
//  WeatherApp
//
//  Created by August Posner on 2018-03-12.
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
        return String(format: "%.2f", temp)
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
    
    
}


class WeatherGetter {
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    private let findUrl = "http://api.openweathermap.org/data/2.5/find?q="
    private let key = "a76b67437a8cec7057729e1b0dfe910f"
   
    func getWeatherAsync(cityID: Int, completed: @escaping (WeatherData?) -> ()) {
        let oneUrl = "\(weatherURL)?id=\(cityID)&appid=\(key)"
        
        if let url = URL(string: oneUrl) {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if let unwrappedData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedInstance = try decoder.decode(WeatherData.self, from: unwrappedData)
                        DispatchQueue.main.async {
                            completed(decodedInstance)
                        }
                    } catch {
                        
                    }
                } else {
                    
                }
            }
            task.resume()
        }
    }
    
    func getAllCitiesAsync(city: String, completed: @escaping (WeatherList) -> ()) {
        let allUrl = "\(findUrl)\(city)&units=metric&appid=\(key)"
        let safeUrl = allUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: safeUrl!) {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if let unwrappedData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedInstance = try decoder.decode(WeatherList.self, from: unwrappedData)
                        DispatchQueue.main.async {
                            completed(decodedInstance)
                        }
                    } catch {
                        
                    }
                } else {
                    
                }
            }
            task.resume()
        }
    }
}
