//
//  Ship.swift
//  Spacegame
//
//  Created by MaestroDavo on 13.3.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class Ship {

    var price = ""
    var featuredImage: UIImage?
    
    init(price: String, featuredImage: UIImage)
    {
        self.price = price
        self.featuredImage = featuredImage
    }
    
    static func fetchShips() -> [Ship]
    {
        return [
            Ship(price: "Owned", featuredImage: UIImage(named: "spaceship1")!),
            Ship(price: "250", featuredImage: UIImage(named: "spaceship2")!),
            Ship(price: "500", featuredImage: UIImage(named: "spaceship3")!),
            Ship(price: "1 000", featuredImage: UIImage(named: "spaceship4")!),
            Ship(price: "2 000", featuredImage: UIImage(named: "spaceship5")!),
            Ship(price: "4 000", featuredImage: UIImage(named: "spaceship6")!),
            Ship(price: "8 000", featuredImage: UIImage(named: "spaceship7")!),
            Ship(price: "16 000", featuredImage: UIImage(named: "spaceship8")!)
        ]
    }

}
