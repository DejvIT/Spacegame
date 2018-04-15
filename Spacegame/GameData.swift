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
    
    let keys = (
        coins: "Coins",
        play_ship: "PlayShip",
        bought_ships: "BoughtShips",
        selected_ship_shop: "SelectedShipInShop",
        first_app_run_done: "FirstAppRun"
        
    )
    
    //Default user data
    var coins:Int = 0
    var playShip:String = "spaceship1"
    var boughtShips = [true, false, false, false, false ,false ,false, false]
    var selectedShipInShop = [false, false, false, false, false ,false ,false, false]
    var firstAppRunDone:Bool = false
    // end of default user data
    
    public func saveUserDefaultsCoins() {
        defaults.set(coins, forKey: keys.coins)
    }
    
    public func saveUserDefaultsPlayShip() {
        defaults.set(playShip, forKey: keys.play_ship)
    }
    
    public func saveUserDefaultsBoughtShips(index: Int, bool: Bool) {
//        var newArray = defaults.array(forKey: )  as? [Bool] ?? [Bool]()
//        newArray[index] = bool
        
        boughtShips[index] = bool
        defaults.set(boughtShips, forKey: keys.bought_ships)
    }
    
    public func setAllShipsToBuy() {
        //var newArray = defaults.array(forKey: "BoughtShips")  as? [Bool] ?? [Bool]()
        
        var i = 1
        while i < boughtShips.count {
            
            boughtShips[i] = false
            i = i + 1
        }
        
        defaults.set(boughtShips, forKey: keys.bought_ships)
    }
    
    public func saveUserDefaultsSelectedShipInShop(index: Int, bool: Bool) {
        
        var i = 0
        while i < selectedShipInShop.count {
            
            selectedShipInShop[i] = false
            i = i + 1
        }
        
        selectedShipInShop[index] = bool
        defaults.set(selectedShipInShop, forKey: keys.selected_ship_shop)
    }
    
    public func saveUserDefaultsFirstAppRunDone(bool: Bool) {
        firstAppRunDone = bool
        defaults.set(firstAppRunDone, forKey: keys.first_app_run_done)
    }
    
    
    public func addCoins(amount: Int) {
        coins = defaults.integer(forKey: keys.coins) + amount
        saveUserDefaultsCoins()
    }
    
    public func removeAllUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        
        print(Array(defaults.dictionaryRepresentation().keys).count)
    }
}
