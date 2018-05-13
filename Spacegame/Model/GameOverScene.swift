//
//  GameOverScene.swift
//  Spacegame
//
//  Created by MaestroDavo on 6.2.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    weak var gameController: GameViewController?
    
    var gameData = GameData.shared

    var starfield:SKEmitterNode?
    
    var backToMenu:SKSpriteNode?
    var coinLabelNode:SKLabelNode?
    var coins:Int = 0
    
    /**
        Set up the view with labels, animation and button
     **/
    override func didMove(to view: SKView) {
        
        self.run(SKAction.playSoundFileNamed("mission_failed.mp3", waitForCompletion: false))
        
        starfield = self.childNode(withName: "starfield") as? SKEmitterNode
        starfield?.advanceSimulationTime(10)
        starfield?.zPosition = -1
        
        backToMenu = self.childNode(withName: "backToMenu") as? SKSpriteNode
        
        coinLabelNode = self.childNode(withName: "coinLabelNode") as? SKLabelNode
        coinLabelNode?.text = "\(coins)"
        
    }
    
    /**
        This method notify when button is pressed.
        Save earned coins from the game and initialize menu scene.
     **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first?.name == "backToMenu") {
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let menuScene = SKScene(fileNamed: "MenuScene") as! MenuScene
                menuScene.gameController = self.gameController
                self.gameData.coins = self.gameData.defaults.integer(forKey: gameData.keys.coins) + self.coins
                self.gameData.saveUserDefaultsCoins()
                self.view?.presentScene(menuScene, transition:transition)
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
