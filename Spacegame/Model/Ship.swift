//
//  Ship.swift
//  Spacegame
//
//  Created by MaestroDavo on 13.3.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class Ship {

    var price:Int
    var featuredImage: UIImage?
    var owned:Bool
    var name:String
    var selectedShip:Bool
    
    init(price: Int, featuredImage: UIImage, owned: Bool, name: String, selectedShip: Bool)
    {
        self.price = price
        self.featuredImage = featuredImage
        self.owned = owned
        self.name = name
        self.selectedShip = selectedShip
    }
    
    static func fetchShips() -> [Ship]
    {
        let gameData = GameData.shared
        let boughtShip = gameData.defaults.array(forKey: gameData.keys.bought_ships)  as? [Bool] ?? [Bool]()
        let selectedShip = gameData.defaults.array(forKey: gameData.keys.selected_ship_shop) as? [Bool] ?? [Bool]()
        
        return [
            Ship(price: 0, featuredImage: UIImage(named: "spaceship1")!, owned: boughtShip[0], name: "spaceship1", selectedShip: selectedShip[0]),
            Ship(price: 250, featuredImage: UIImage(named: "spaceship2")!, owned: boughtShip[1], name: "spaceship2", selectedShip: selectedShip[1]),
            Ship(price: 500, featuredImage: UIImage(named: "spaceship3")!, owned: boughtShip[2], name: "spaceship3", selectedShip: selectedShip[2]),
            Ship(price: 1000, featuredImage: UIImage(named: "spaceship4")!, owned: boughtShip[3], name: "spaceship4", selectedShip: selectedShip[3]),
            Ship(price: 2000, featuredImage: UIImage(named: "spaceship5")!, owned: boughtShip[4], name: "spaceship5", selectedShip: selectedShip[4]),
            Ship(price: 4000, featuredImage: UIImage(named: "spaceship6")!, owned: boughtShip[5], name: "spaceship6", selectedShip: selectedShip[5]),
            Ship(price: 8000, featuredImage: UIImage(named: "spaceship7")!, owned: boughtShip[6], name: "spaceship7", selectedShip: selectedShip[6]),
            Ship(price: 16000, featuredImage: UIImage(named: "spaceship8")!, owned: boughtShip[7], name: "spaceship8", selectedShip: selectedShip[7])
        ]
    }
}
