//
//  Fireball.swift
//  Spacegame
//
//  Created by MaestroDavo on 4.4.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class Fireball {

    var price = ""
    var featuredImage: UIImage?
    
    init(price: String, featuredImage: UIImage)
    {
        self.price = price
        self.featuredImage = featuredImage
    }
    
    static func fetchFireballs() -> [Fireball]
    {
        return [
            Fireball(price: "Owned", featuredImage: UIImage(named: "fireball1-classic")!),
            Fireball(price: "100", featuredImage: UIImage(named: "fireball2-yellow")!),
            Fireball(price: "200", featuredImage: UIImage(named: "fireball3-red")!),
            Fireball(price: "400", featuredImage: UIImage(named: "fireball4-boom")!),
            Fireball(price: "800", featuredImage: UIImage(named: "fireball5-light")!),
            Fireball(price: "1 000", featuredImage: UIImage(named: "fireball6-green")!),
            Fireball(price: "2 000", featuredImage: UIImage(named: "fireball7-white")!),
            Fireball(price: "5 000", featuredImage: UIImage(named: "fireball8-black")!),
            Fireball(price: "12 000", featuredImage: UIImage(named: "fireball9-blue")!),
            Fireball(price: "15 000", featuredImage: UIImage(named: "fireball10-darkblue")!),
            Fireball(price: "18 000", featuredImage: UIImage(named: "fireball11-purple")!),
            Fireball(price: "20 000", featuredImage: UIImage(named: "fireball12-storm")!),
            Fireball(price: "22 000", featuredImage: UIImage(named: "fireball13-lightpink")!),
            Fireball(price: "23 000", featuredImage: UIImage(named: "fireball14-pink")!),
            Fireball(price: "25 000", featuredImage: UIImage(named: "fireball15-pinky")!),
            Fireball(price: "30 000", featuredImage: UIImage(named: "fireball16-pinkeye")!),
            Fireball(price: "32 000", featuredImage: UIImage(named: "fireball17-colorful")!),
            Fireball(price: "38 000", featuredImage: UIImage(named: "fireball18-blackhole")!)
        ]
    }
}
