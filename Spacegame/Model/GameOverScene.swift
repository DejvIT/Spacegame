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
    var shots:Int = 0
    var seconds:Int = 0
    var gameDifficulty:Int = 1
    
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
        
        manageStatistics()
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
    
    /**
     If player reached higher score the data will upload and save into the memory
     **/
    func manageStatistics() {
        
        let arrayScore = gameData.defaults.array(forKey: gameData.keys.best_score)  as? [Int] ?? [Int]()
        let arrayShots = gameData.defaults.array(forKey: gameData.keys.most_shots)  as? [Int] ?? [Int]()
        let arrayTime = gameData.defaults.array(forKey: gameData.keys.longest_game)  as? [Int] ?? [Int]()
        
        if gameDifficulty == 3 {
            if arrayScore[2] < coins {
                gameData.saveUserDefaultsBestScore(index: 2, amount: coins)
            }
            
            if arrayShots[2] < shots {
                gameData.saveUserDefaultsMostShots(index: 2, amount: shots)
            }
            
            if arrayTime[2] < seconds {
                gameData.saveUserDefaultsLongestGame(index: 2, seconds: seconds)
            }
        } else if gameDifficulty == 2 {
            if arrayScore[1] < coins {
                gameData.saveUserDefaultsBestScore(index: 1, amount: coins)
            }
            
            if arrayShots[1] < shots {
                gameData.saveUserDefaultsMostShots(index: 1, amount: shots)
            }
            
            if arrayTime[1] < seconds {
                gameData.saveUserDefaultsLongestGame(index: 1, seconds: seconds)
            }
        } else {
            if arrayScore[0] < coins {
                gameData.saveUserDefaultsBestScore(index: 0, amount: coins)
            }
            
            if arrayShots[0] < shots {
                gameData.saveUserDefaultsMostShots(index: 0, amount: shots)
            }
            
            if arrayTime[0] < seconds {
                gameData.saveUserDefaultsLongestGame(index: 0, seconds: seconds)
            }
        }
    }
    
    
    

    
}
