//
//  GameOverScene.swift
//  Spacegame
//
//  Created by MaestroDavo on 6.2.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var gameData = GameData.shared

    var starfield:SKEmitterNode?
    
    var backToMenu:SKSpriteNode?
    var coinLabelNode:SKLabelNode?
    var coins:Int = 0
    
    override func didMove(to view: SKView) {
        
        starfield = self.childNode(withName: "starfield") as? SKEmitterNode
        starfield?.advanceSimulationTime(10)
        starfield?.zPosition = -1
        
        backToMenu = self.childNode(withName: "backToMenu") as? SKSpriteNode
        
        coinLabelNode = self.childNode(withName: "coinLabelNode") as? SKLabelNode
        coinLabelNode?.text = "\(coins)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first?.name == "backToMenu") {
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = SKScene(fileNamed: "MenuScene") as! MenuScene
                self.gameData.coins = self.gameData.defaults.integer(forKey: gameData.keys.coins) + self.coins
                self.gameData.saveUserDefaultsCoins()
                self.view?.presentScene(gameScene, transition:transition)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
