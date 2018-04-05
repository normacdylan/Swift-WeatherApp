//
//  WeatherGetter.swift
//  WeatherApp
//
//  Created by August Posner on 2018-03-12.
//  Copyright © 2018 August Posner. All rights reserved.
//

import Foundation

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
