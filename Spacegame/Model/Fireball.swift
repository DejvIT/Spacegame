//
//  Fireball.swift
//  Spacegame
//
//  Created by MaestroDavo on 4.4.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class Fireball {

    var price:Int
    var featuredImage: UIImage?
    var owned:Bool
    var name:String
    var selectedFireball:Bool
    
    init(price: Int, featuredImage: UIImage, owned: Bool, name: String, selectedFireball: Bool)
    {
        self.price = price
        self.featuredImage = featuredImage
        self.owned = owned
        self.name = name
        self.selectedFireball = selectedFireball
    }
    
    public func changeSelection() -> Bool {
        return !self.selectedFireball
    }
    
    static func fetchFireballs() -> [Fireball]
    {
        let gameData = GameData.shared
        let boughtFireball = gameData.defaults.array(forKey: gameData.keys.bought_fireballs)  as? [Bool] ?? [Bool]()
        let selectedFireball = gameData.defaults.array(forKey: gameData.keys.selected_fireball_shop) as? [Bool] ?? [Bool]()
        
        return [
            Fireball(price: 0, featuredImage: UIImage(named: "fireball1-classic")!, owned: boughtFireball[0], name: "fireball1-classic", selectedFireball: selectedFireball[0]),
            Fireball(price: 100, featuredImage: UIImage(named: "fireball2-yellow")!, owned: boughtFireball[1], name: "fireball2-yellow", selectedFireball: selectedFireball[1]),
            Fireball(price: 200, featuredImage: UIImage(named: "fireball3-red")!, owned: boughtFireball[2], name: "fireball3-red", selectedFireball: selectedFireball[2]),
            Fireball(price: 400, featuredImage: UIImage(named: "fireball4-boom")!, owned: boughtFireball[3], name: "fireball4-boom", selectedFireball: selectedFireball[3]),
            Fireball(price: 800, featuredImage: UIImage(named: "fireball5-light")!, owned: boughtFireball[4], name: "fireball5-light", selectedFireball: selectedFireball[4]),
            Fireball(price: 1000, featuredImage: UIImage(named: "fireball6-green")!, owned: boughtFireball[5], name: "fireball6-green", selectedFireball: selectedFireball[5]),
            Fireball(price: 2000, featuredImage: UIImage(named: "fireball7-white")!, owned: boughtFireball[6], name: "fireball7-white", selectedFireball: selectedFireball[6]),
            Fireball(price: 5000, featuredImage: UIImage(named: "fireball8-black")!, owned: boughtFireball[7], name: "fireball8-black", selectedFireball: selectedFireball[7]),
            Fireball(price: 12000, featuredImage: UIImage(named: "fireball9-blue")!, owned: boughtFireball[8], name: "fireball9-blue", selectedFireball: selectedFireball[8]),
            Fireball(price: 15000, featuredImage: UIImage(named: "fireball10-darkblue")!, owned: boughtFireball[9], name: "fireball10-darkblue", selectedFireball: selectedFireball[9]),
            Fireball(price: 18000, featuredImage: UIImage(named: "fireball11-purple")!, owned: boughtFireball[10], name: "fireball11-purple", selectedFireball: selectedFireball[10]),
            Fireball(price: 20000, featuredImage: UIImage(named: "fireball12-storm")!, owned: boughtFireball[11], name: "fireball12-storm", selectedFireball: selectedFireball[11]),
            Fireball(price: 22000, featuredImage: UIImage(named: "fireball13-lightpink")!, owned: boughtFireball[12], name: "fireball13-lightpink", selectedFireball: selectedFireball[12]),
            Fireball(price: 23000, featuredImage: UIImage(named: "fireball14-pink")!, owned: boughtFireball[13], name: "fireball14-pink", selectedFireball: selectedFireball[13]),
            Fireball(price: 25000, featuredImage: UIImage(named: "fireball15-pinky")!, owned: boughtFireball[14], name: "fireball15-pinky", selectedFireball: selectedFireball[14]),
            Fireball(price: 30000, featuredImage: UIImage(named: "fireball16-pinkeye")!, owned: boughtFireball[15], name: "fireball16-pinkeye", selectedFireball: selectedFireball[15]),
            Fireball(price: 32000, featuredImage: UIImage(named: "fireball17-colorful")!, owned: boughtFireball[16], name: "fireball17-colorful", selectedFireball: selectedFireball[16]),
            Fireball(price: 38000, featuredImage: UIImage(named: "fireball18-blackhole")!, owned: boughtFireball[17], name: "fireball18-blackhole", selectedFireball: selectedFireball[17])
        ]
    }
}
