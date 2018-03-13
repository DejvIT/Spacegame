//
//  Ship.swift
//  Spacegame
//
//  Created by MaestroDavo on 13.3.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class Ship {

    // MARK: - Public API
    var price = ""
    var featuredImage: UIImage
    
    init(price: String, featuredImage: UIImage)
    {
        self.price = price
        self.featuredImage = featuredImage
    }
    
    // MARK: - Private
    // dummy data
    static func fetchShips() -> [Ship]
    {
        return [
            Ship(price: "1 000", featuredImage: UIImage(named: "vesmirnaLod")!),
            Ship(price: "5 000", featuredImage: UIImage(named: "diablik")!),
            Ship(price: "10 000", featuredImage: UIImage(named: "alien")!),
            Ship(price: "20 000", featuredImage: UIImage(named: "alien3")!),
            Ship(price: "1000 000", featuredImage: UIImage(named: "alien-spaceship")!)
        ]
    }

}
