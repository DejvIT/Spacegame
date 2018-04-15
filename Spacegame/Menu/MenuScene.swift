//
//  MenuScene.swift
//  Spacegame
//
//  Created by MaestroDavo on 1.2.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var gameData = GameData.shared
    
    weak var gameController: GameViewController?
    
    weak var starfield:SKEmitterNode?
    
    weak var newGameButtonNode:SKSpriteNode?
    weak var difficultyButtonNode:SKSpriteNode?
    weak var difficultyLabelNode:SKLabelNode?
    weak var coinLabelNode:SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        //gameData.removeAllUserDefaults()
        //gameData.addCoins(amount: 10000)
        
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
        
        if !gameData.defaults.bool(forKey: gameData.keys.first_app_run_done) {
            
            gameData.saveUserDefaultsPlayShip()
            gameData.saveUserDefaultsSelectedShipInShop(index: 0, bool: true)
            gameData.saveUserDefaultsBoughtShips(index: 0, bool: true)
            gameData.saveUserDefaultsFirstAppRunDone(bool: true)
        }
        
        coinLabelNode = self.childNode(withName: "coinLabel") as? SKLabelNode
        coinManager()
        
        print("SpaceShip: " + gameData.defaults.string(forKey: gameData.keys.play_ship)!)
        print("Coins: " + String(gameData.defaults.integer(forKey: gameData.keys.coins)))
        let array = gameData.defaults.array(forKey: gameData.keys.bought_ships)  as? [Bool] ?? [Bool]()
        print(array)
        print("FirstRun: " + String(gameData.defaults.bool(forKey: gameData.keys.first_app_run_done)))
        let playShip = gameData.defaults.array(forKey: gameData.keys.selected_ship_shop)  as? [Bool] ?? [Bool]()
        print(playShip)
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
        
        let coins = gameData.defaults.integer(forKey: gameData.keys.coins)
        self.coinLabelNode?.text = String(coins)
        self.gameData.coins = coins
        self.gameData.saveUserDefaultsCoins()
        
    }
}






































