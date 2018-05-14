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
    
    //Keys stored in device's memory.
    let keys = (
        coins: "Coins",
        play_ship: "PlayShip",
        bought_ships: "BoughtShips",
        selected_ship_shop: "SelectedShipInShop",
        first_app_run_done: "FirstAppRun",
        bought_fireballs: "BoughtFireballs",
        selected_fireball_shop: "SelectedFireballInShop",
        play_fireballs: "PlayFireballs",
        game_difficulty: "GameDifficulty",
        best_score: "BestScore",
        most_shots: "MostShots",
        longest_game: "LongestGame"
    )
    
    //Default user data
    var coins:Int = 0
    var playShip:String = "spaceship1"
    var boughtShips:[Bool] = [true, false, false, false, false ,false ,false, false]
    var selectedShipInShop:[Bool] = [false, false, false, false, false ,false ,false, false]
    var firstAppRunDone:Bool = false
    var boughtFireballs:[Bool] = [true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    var selectedFireballInShop:[Bool] = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
    var gameDifficulty:Int = 0
    var bestScore:[Int] = [0, 0, 0]
    var mostShots:[Int] = [0, 0, 0]
    var longestGame:[Int] = [0, 0, 0]
    // end of default user data
    
    //Save user's coins
    public func saveUserDefaultsCoins() {
        defaults.set(coins, forKey: keys.coins)
    }
    
    //Save user's selected ship in the shop, which will be spawned in the game.
    public func saveUserDefaultsPlayShip() {
        defaults.set(playShip, forKey: keys.play_ship)
    }
    
    //Save all ships user already bought
    public func saveUserDefaultsBoughtShips(index: Int, bool: Bool) {
        boughtShips = defaults.array(forKey: keys.bought_ships)  as? [Bool] ?? [Bool]()
        boughtShips[index] = bool
        defaults.set(boughtShips, forKey: keys.bought_ships)
    }
    
    //Clear from shop for all ships
    public func setAllShipsToBuy() {
        
        var i = 1
        while i < boughtShips.count {
            
            boughtShips[i] = false
            i = i + 1
        }
        
        defaults.set(boughtShips, forKey: keys.bought_ships)
    }
    
    //Save which ship is selected by user
    public func saveUserDefaultsSelectedShipInShop(index: Int, bool: Bool) {
        
        var i = 0
        while i < selectedShipInShop.count {
            
            selectedShipInShop[i] = false
            i = i + 1
        }
        
        selectedShipInShop[index] = bool
        defaults.set(selectedShipInShop, forKey: keys.selected_ship_shop)
    }
    
    //Save that application was already run
    public func saveUserDefaultsFirstAppRunDone(bool: Bool) {
        firstAppRunDone = bool
        defaults.set(firstAppRunDone, forKey: keys.first_app_run_done)
    }
    
    //Save all fireballs user already bought in the shop
    public func saveUserDefaultsBoughtFireballs(index: Int, bool: Bool) {
        boughtFireballs = defaults.array(forKey: keys.bought_fireballs)  as? [Bool] ?? [Bool]()
        boughtFireballs[index] = bool
        defaults.set(boughtFireballs, forKey: keys.bought_fireballs)
    }
    
    //Clear all data about bought fireballs
    public func setAllFireballsToBuy() {
        
        var i = 1
        while i < boughtFireballs.count {
            
            boughtFireballs[i] = false
            i += 1
        }
        
        defaults.set(boughtFireballs, forKey: keys.bought_fireballs)
    }
    
    //Save which fireballs are selected in the shop and will be used in the game
    public func saveUserDefaultsSelectedFireballsInShop(index: Int, bool: Bool) {
        selectedFireballInShop = defaults.array(forKey: keys.selected_fireball_shop)  as? [Bool] ?? [Bool]()
        selectedFireballInShop[index] = bool
        defaults.set(selectedFireballInShop, forKey: keys.selected_fireball_shop)
    }
    
    //Add and save some coins
    public func addCoins(amount: Int) {
        coins = defaults.integer(forKey: keys.coins) + amount
        saveUserDefaultsCoins()
    }
    
    //Initialize shop settings when first time run
    public func initialShopSettings(index: Int) {
        
        boughtShips[index] = true
        defaults.set(boughtShips, forKey: keys.bought_ships)
        boughtFireballs[index] = true
        defaults.set(boughtFireballs, forKey: keys.bought_fireballs)
        selectedFireballInShop[index] = true
        defaults.set(selectedFireballInShop, forKey: keys.selected_fireball_shop)
    }
    
    //Save choosen difficulty
    public func saveUserDefaultsChangeGameDifficulty() {
        gameDifficulty = defaults.integer(forKey: keys.game_difficulty)
        gameDifficulty += 1
        
        if gameDifficulty > 3 {
            gameDifficulty = 1
        }
        
        defaults.set(gameDifficulty, forKey: keys.game_difficulty)
    }
    
    //Save best score for game difficulty
    public func saveUserDefaultsBestScore(index: Int, amount: Int) {
        bestScore = defaults.array(forKey: keys.best_score) as? [Int] ?? [Int]()
        bestScore[index] = amount
        defaults.set(bestScore, forKey: keys.best_score)
    }
    
    //Save most shots fired in the game according to difficulty settings
    public func saveUserDefaultsMostShots(index: Int, amount: Int) {
        mostShots = defaults.array(forKey: keys.most_shots) as? [Int] ?? [Int]()
        mostShots[index] = amount
        defaults.set(mostShots, forKey: keys.most_shots)
    }
    
    //Save the longest game according to every game difficulty
    public func saveUserDefaultsLongestGame(index: Int, seconds: Int) {
        longestGame = defaults.array(forKey: keys.longest_game) as? [Int] ?? [Int]()
        longestGame[index] = seconds
        defaults.set(longestGame, forKey: keys.longest_game)
    }
    
    public func setInitialStatistics() {
        defaults.set(bestScore, forKey: keys.best_score)
        defaults.set(mostShots, forKey: keys.most_shots)
        defaults.set(longestGame, forKey: keys.longest_game)
    }
    
    //Clear all user defaults settings = reinstall app
    public func removeAllUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        
        print(Array(defaults.dictionaryRepresentation().keys).count)
    }
}
