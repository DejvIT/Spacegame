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
    
    init(price: Int, featuredImage: UIImage, owned: Bool, name: String)
    {
        self.price = price
        self.featuredImage = featuredImage
        self.owned = owned
        self.name = name
    }
    
    static func fetchShips() -> [Ship]
    {
        return [
            Ship(price: 0, featuredImage: UIImage(named: "spaceship1")!, owned: true, name: "spaceship1"),
            Ship(price: 250, featuredImage: UIImage(named: "spaceship2")!, owned: false, name: "spaceship2"),
            Ship(price: 500, featuredImage: UIImage(named: "spaceship3")!, owned: false, name: "spaceship3"),
            Ship(price: 1000, featuredImage: UIImage(named: "spaceship4")!, owned: false, name: "spaceship4"),
            Ship(price: 2000, featuredImage: UIImage(named: "spaceship5")!, owned: false, name: "spaceship5"),
            Ship(price: 4000, featuredImage: UIImage(named: "spaceship6")!, owned: false, name: "spaceship6"),
            Ship(price: 8000, featuredImage: UIImage(named: "spaceship7")!, owned: false, name: "spaceship7"),
            Ship(price: 16000, featuredImage: UIImage(named: "spaceship8")!, owned: false, name: "spaceship8")
        ]
    }
}
