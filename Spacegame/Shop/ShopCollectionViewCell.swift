//
//  ShopCollectionViewCell.swift
//  Spacegame
//
//  Created by MaestroDavo on 13.3.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var shipPriceLabel: UILabel!
    
    var ship: Ship? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let ship = ship {
            featuredImageView.image = ship.featuredImage
            shipPriceLabel.text = ship.price
        } else {
            featuredImageView.image = nil
            shipPriceLabel.text = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
}
