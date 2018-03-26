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
    
    func load() -> [Int] {
        let savedData = userDefaults.object(forKey: key)
        return savedData is [Int] ? savedData as! [Int] : []
    }
    
    private func save(_ data: [Int]) {
        userDefaults.set(data, forKey: key)
    }
    
    func add(cityID: Int) {
        if !isSaved(cityID) {
            var savedData = load()
            savedData.append(cityID)
            save(savedData)
        }
    }
    
    func delete(cityID: Int) {
        let newData = load().filter{$0 != cityID}
        save(newData)
    }
    
    func isSaved(_ cityID: Int) -> Bool {
        return load().contains(cityID)
    }
    
}

