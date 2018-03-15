//
//  DBHelper.swift
//  WeatherApp
//
//  Created by August Posner on 2018-03-15.
//  Copyright © 2018 August Posner. All rights reserved.
//

import Foundation
class DBHelper {
    
    private let key = "savedData"
    private let userDefaults = UserDefaults.standard
    
    func getSavedData() -> [String] {
        let savedData = userDefaults.object(forKey: key)
        return savedData is [String] ? savedData as! [String] : []
    }
    
    private func save(_ data: [String]) {
        userDefaults.set(data, forKey: key)
    }
    
    func add(city: String) {
        if !isSaved(city) {
            var savedData = getSavedData()
            savedData.append(city)
            save(savedData)
        }
    }
    
    func delete(city: String) {
        let newData = getSavedData().filter{$0 != city}
        save(newData)
    }
    
    func isSaved(_ city: String) -> Bool {
        return getSavedData().contains(city)
    }
    
}

