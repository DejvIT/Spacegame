//
//  FireballCollectionViewCell.swift
//  Spacegame
//
//  Created by MaestroDavo on 4.4.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class FireballCollectionViewCell: UICollectionViewCell {
    
    var gameData = GameData.shared
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var fireballPriceLabel: UILabel!
    
    var fireball: Fireball? {
        didSet {
            self.updateUI()
        }
    }
    
    /**
     Update competent collection view cell when something is changed.
     **/
    private func updateUI()
    {
        if let fireball = fireball {
            featuredImageView?.image = fireball.featuredImage
            
            print("Owned? " + String(fireball.owned))
            print("Selected? " + String(fireball.selectedFireball))
            
            if fireball.owned {
                fireballPriceLabel.text = "Owned"
            } else {
                fireballPriceLabel.text = String(fireball.price)
            }
            
            if fireball.selectedFireball {
                featuredImageView.layer.backgroundColor = bgColorSelected.cgColor
                fireballPriceLabel.text = "Selected"
            } else {
                featuredImageView.layer.backgroundColor = bgColorDefault.cgColor
            }
        } else {
            featuredImageView?.image = nil
            fireballPriceLabel?.text = nil
        }
    }
    
    /**
     Additional settings
     **/
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
    
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
}

