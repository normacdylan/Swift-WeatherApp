//
//  WeatherGetter.swift
//  WeatherApp
//
//  Created by August Posner on 2018-03-12.
//  Copyright © 2018 August Posner. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let message: Double
    let country: String
    let sunrise: Double
    let sunset: Double
}

struct WeatherData: Codable {
    let coord: [String : Double]
    let weather: [Weather]
    let base: String
    let main: [String : Double]
    let wind: [String : Double]
    let clouds: [String : Double]
    let rain: [String : Double]?
    let snow: [String : Double]?
    let dt: Date
    let sys: Sys
    let id: Int
    let name: String
    let cod: Int
    
    var temp: Double {
        return main["temp"]! - 273.15
    }
    
    var tempString: String {
        return String(format: "%.2f", temp)
    }
    
    var cloudiness: Double {
        return clouds["all"]!
    }
    
    var windSpeed: Double {
        return wind["speed"]!
    }
    
    var sunUp: Date {
        let date = Date(timeIntervalSince1970: sys.sunrise)
        return date
    }
    
    var sunUpString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: sunUp)
    }
    
    var sunDown: Date {
        let date = Date(timeIntervalSince1970: sys.sunset)
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
    private let key = "a76b67437a8cec7057729e1b0dfe910f"
  
    func foundCity(_ city: String) -> Bool {
        if let result = getWeatherString(city: city) {
            return result.range(of: "city not found") == nil
        }
        return false
    }
 
    
    //Gör om till data istället för string?
    func getWeatherString(city: String) -> String? {
        let urlString = "\(weatherURL)?APPID=\(key)&q=\(city)"
        if let safeUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: safeUrl) {
            do {
                let data = try String(contentsOf: url)
                return data
            } catch {
               // return "Contents could not be loaded"
            }
        } else {
            return "The URL was bad"
        }
        return nil
    }
    
    func getDataAsync(city: String, completed: @escaping (_ : WeatherData?) -> ()) {
        if let url = URL(string: "\(weatherURL)?APPID=\(key)&q=\(city)") {
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
    
    func getWeather(city: String) -> WeatherData {
        return parseData(data: getWeatherString(city: city)!)
    }
    
    func parseData(data: String) -> WeatherData {
        let jsonData = data.data(using: .utf8)!
        let decoder = JSONDecoder()
        let weatherData = try! decoder.decode(WeatherData.self, from: jsonData)
        return weatherData
    }
    
   
}
