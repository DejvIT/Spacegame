//
//  FireballCollectionViewCell.swift
//  Spacegame
//
//  Created by MaestroDavo on 4.4.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class FireballCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var fireballPriceLabel: UILabel!
    
    var fireball: Fireball? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let fireball = fireball {
            featuredImageView?.image = fireball.featuredImage
            fireballPriceLabel?.text = fireball.price
        } else {
            featuredImageView?.image = nil
            fireballPriceLabel?.text = nil
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

