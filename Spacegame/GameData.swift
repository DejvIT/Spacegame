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
    
    public func saveUserDefaultsCoins() {
        defaults.set(coins, forKey: "Coins")
    }
    
    public func saveUserDefaultsShip() {
        defaults.set(selectedShip, forKey: "ShipKey")
    }
}
