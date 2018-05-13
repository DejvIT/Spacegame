//
//  FireballController.swift
//  Spacegame
//
//  Created by MaestroDavo on 5.4.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import UIKit

class FireballController: UIViewController {

    var gameData = GameData.shared
    
    @IBOutlet weak var coinLabel: UILabel!
    var coins:Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var fireballs = Fireball.fetchFireballs()
    let cellScaling: CGFloat = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.coins = self.gameData.defaults.integer(forKey: gameData.keys.coins)
        self.coinLabel?.text = String(self.coins!)
    }
    
    public func getNumsOfSelectedFireballs() -> Int {
        var i:Int = 0
        var amount:Int = 0
        
        while i < self.fireballs.count {
            if self.fireballs[i].selectedFireball {
                amount += 1
            }
            i += 1
        }
        
        return amount
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Private
private extension FireballController {
    func fireballForIndexPath(_ indexPath: IndexPath) -> Fireball {
        return fireballs[(indexPath as NSIndexPath).row]
    }
}

extension FireballController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fireballs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fireballCell", for: indexPath) as! FireballCollectionViewCell
        
        cell.fireball = fireballs[indexPath.item]
        
        print(getNumsOfSelectedFireballs())
        
        return cell
    }
}

extension FireballController : UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let selectedFireball = fireballForIndexPath(indexPath)
        print("Index of cell: " + String(indexPath.row))
        
        if self.coins >= selectedFireball.price || selectedFireball.owned {
            
            if !selectedFireball.owned {
                self.coins = self.coins - selectedFireball.price
                self.coinLabel.text = String(self.coins)
                selectedFireball.owned = true
                
                self.gameData.saveUserDefaultsBoughtFireballs(index: indexPath.row, bool: true)
                self.fireballs = Fireball.fetchFireballs()
                self.gameData.coins = self.coins
                self.gameData.saveUserDefaultsCoins()
            }
            
            print(getNumsOfSelectedFireballs())
            if getNumsOfSelectedFireballs() > 0 {
                selectedFireball.selectedFireball = selectedFireball.changeSelection()
                
                self.gameData.saveUserDefaultsSelectedFireballsInShop(index: indexPath.row, bool: selectedFireball.selectedFireball)
                self.fireballs = Fireball.fetchFireballs()
                
                print(getNumsOfSelectedFireballs())
                if getNumsOfSelectedFireballs() == 0 {
                    selectedFireball.selectedFireball = selectedFireball.changeSelection()
                    
                    self.gameData.saveUserDefaultsSelectedFireballsInShop(index: indexPath.row, bool: selectedFireball.selectedFireball)
                    self.fireballs = Fireball.fetchFireballs()
                }
            }
            
            let array = gameData.defaults.array(forKey: gameData.keys.bought_fireballs)  as? [Bool] ?? [Bool]()
            print(array)
            let selectedFireballs = gameData.defaults.array(forKey: gameData.keys.selected_fireball_shop)  as? [Bool] ?? [Bool]()
            print(selectedFireballs)
            print(selectedFireball.selectedFireball)
            
            return true
            }
        
        
        return false
    }
}
































