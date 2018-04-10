//
//  GameData.swift
//  Spacegame
//
//  Created by MaestroDavo on 7.4.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

//Singleton

import UIKit

class GameData {

    static let shared = GameData()
    
    let defaults = UserDefaults.standard
    
    var coins:Int = 0
    var selectedShip:String = "spaceship1"
    var boughtShips = [true, false, false, false, false ,false ,false, false]
    
    public func saveUserDefaultsCoins() {
        defaults.set(coins, forKey: "Coins")
    }
    
    public func saveUserDefaultsShip() {
        defaults.set(selectedShip, forKey: "ShipKey")
    }
    
    public func saveUserDefaultsShip(index: Int, bool: Bool) {
        var newArray = defaults.array(forKey: "BoughtShips")  as? [Bool] ?? [Bool]()
        newArray[index] = bool
        defaults.set(newArray, forKey: "BoughtShips")
    }
    
    public func setAllShipsToBuy() {
        var newArray = defaults.array(forKey: "BoughtShips")  as? [Bool] ?? [Bool]()
        
        var i = 0
        while i < newArray.count {
            newArray[i] = false
            i = i + 1
        }
        
        defaults.set(newArray, forKey: "BoughtShips")
    }
}
