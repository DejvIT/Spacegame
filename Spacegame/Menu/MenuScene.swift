//
//  MenuScene.swift
//  Spacegame
//
//  Created by MaestroDavo on 1.2.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var gameController: GameViewController?
    
    var starfield:SKEmitterNode?
    var SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    var newGameButtonNode:SKSpriteNode?
    var difficultyButtonNode:SKSpriteNode?
    var difficultyLabelNode:SKLabelNode?
    var coinLabelNode:SKLabelNode?
    
    var coins:Int = 0
    var totalCoins = UserDefaults.standard.integer(forKey: "TOTALCOINS")
    
    override func didMove(to view: SKView) {
        
        starfield = self.childNode(withName: "starfield") as? SKEmitterNode
        starfield?.advanceSimulationTime(10)
        starfield?.zPosition = -1
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        
        difficultyButtonNode = self.childNode(withName: "difficultyButton") as? SKSpriteNode
        
        difficultyLabelNode = self.childNode(withName: "difficultyLabel") as? SKLabelNode
        
        let userDefaults = UserDefaults.standard
        
        if (userDefaults.bool(forKey: "hard")) {
            difficultyLabelNode?.text = "Hard"
        } else {
            difficultyLabelNode?.text = "Easy"
        }
        
        coinLabelNode = self.childNode(withName: "coinLabel") as? SKLabelNode
        coinLabelNode?.text = "\(UserDefaults.standard.integer(forKey: "TOTALCOINS"))"
        coinManager()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first?.name == "newGameButton") {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                gameScene.difficulty = (self.difficultyLabelNode?.text)!
                self.view?.presentScene(gameScene, transition: transition)
            } else if (nodesArray.first?.name == "difficultyButton") {
                changeDifficulty()
            } else if (nodesArray.first?.name == "shopButton") {
                
                gameController?.performSegue(withIdentifier: String(describing: ShopController.self), sender: nil)
            }
        }
    }
    
    func changeDifficulty() {
        let userDefaults = UserDefaults.standard
        
        if (difficultyLabelNode?.text == "Easy") {
            difficultyLabelNode?.text = "Hard"
            userDefaults.set(true, forKey: "hard")
        } else {
            difficultyLabelNode?.text = "Easy"
            userDefaults.set(false, forKey: "hard")
        }
        
        userDefaults.synchronize()
    }
    
    func coinManager() {
        
        if (coinLabelNode?.text == "TEXT") {

            coinLabelNode?.text = "\(coins)"
        } else {

            let x = Int((coinLabelNode?.text)!)! + coins
            coinLabelNode?.text = "\(x)"
        }
        
        UserDefaults.standard.set(Int((coinLabelNode?.text)!)!, forKey: "TOTALCOINS")
        coinLabelNode?.text = "\(UserDefaults.standard.integer(forKey: "TOTALCOINS"))"
        
    }
    
}






































