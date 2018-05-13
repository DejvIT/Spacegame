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
    
    /**
     Updating of ViewCell in the shop.
     **/
    private func updateUI()
    {
        if let ship = ship {
            featuredImageView.image = ship.featuredImage
            
            print("Owned? " + String(ship.owned))
            print("Selected? " + String(ship.selectedShip))
            
            if ship.owned {
                shipPriceLabel.text = "Owned"
            } else {
                shipPriceLabel.text = String(ship.price)
            }
        
            if ship.selectedShip {
                featuredImageView.layer.backgroundColor = bgColorSelected.cgColor
                shipPriceLabel.text = "Selected"
            } else {
                featuredImageView.layer.backgroundColor = bgColorDefault.cgColor
            }
        } else {
            featuredImageView?.image = nil
            shipPriceLabel?.text = nil
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
        isSelected = false
    }
}
