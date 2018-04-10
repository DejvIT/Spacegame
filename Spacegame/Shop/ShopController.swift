//
//  ShopController.swift
//  Spacegame
//
//  Created by MaestroDavo on 13.3.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class ShopController: UIViewController {
    
    var gameData = GameData.shared
    
    @IBOutlet weak var coinLabel: UILabel!
    var coins:Int!
    
    @IBAction func backToMenu(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: "MenuController"), sender: nil)
    }
    
    @IBAction func fireballShop(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: "FireballController"), sender: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ships = Ship.fetchShips()
    let cellScaling: CGFloat = 0.6

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.coins = self.gameData.defaults.integer(forKey: "Coins")
        self.coinLabel.text = String(self.coins)
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Private
private extension ShopController {
    func shipForIndexPath(_ indexPath: IndexPath) -> Ship {
        return ships[(indexPath as NSIndexPath).row]
    }
}

extension ShopController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ships.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shipCell", for: indexPath) as! ShopCollectionViewCell
        
        cell.ship = shipForIndexPath(indexPath)
        return cell
    }
}

extension ShopController : UIScrollViewDelegate, UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let selectedShip = shipForIndexPath(indexPath)
        
        print(indexPath.row)
        if self.coins >= selectedShip.price || selectedShip.owned {
            
            if !selectedShip.owned {
                self.coins = self.coins - selectedShip.price
                self.coinLabel.text = String(self.coins)
                selectedShip.owned = true
            }
            
            self.gameData.saveUserDefaultsShip(index: indexPath.row, bool: true)
            self.gameData.selectedShip = selectedShip.name
            self.gameData.coins = self.coins
            self.gameData.saveUserDefaultsCoins()
            self.gameData.saveUserDefaultsShip()
            
            return true
        }
        return false
    }
}

