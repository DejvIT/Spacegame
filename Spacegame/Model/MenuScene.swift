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
    
    var backgroundMusic:SKAudioNode!
    
    override func didMove(to view: SKView) {
        
        if let musicURL = Bundle.main.url(forResource: "main_menu_music", withExtension: ".mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
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
            gameData.saveUserDefaultsSelectedFireballsInShop(index: 0, bool: true)
            gameData.saveUserDefaultsBoughtShips(index: 0, bool: true)
            gameData.saveUserDefaultsBoughtFireballs(index: 0, bool: true)
            gameData.saveUserDefaultsFirstAppRunDone(bool: true)
            gameData.saveUserDefaultsChangeGameDifficulty()
        }
        
        coinLabelNode = self.childNode(withName: "coinLabel") as? SKLabelNode
        coinManager()

        if gameData.defaults.integer(forKey: gameData.keys.game_difficulty) == 3 {
            difficultyLabelNode?.text = "Chinese"
        } else if gameData.defaults.integer(forKey: gameData.keys.game_difficulty) == 2 {
            difficultyLabelNode?.text = "Normal"
        } else {
            difficultyLabelNode?.text = "Fun"
        }
        
        print("FirstRunDone: " + String(gameData.defaults.bool(forKey: gameData.keys.first_app_run_done)))
        print("SpaceShip: " + gameData.defaults.string(forKey: gameData.keys.play_ship)!)
        print("Coins: " + String(gameData.defaults.integer(forKey: gameData.keys.coins)))
        let arrayBoughtShips = gameData.defaults.array(forKey: gameData.keys.bought_ships)  as? [Bool] ?? [Bool]()
        print("\nBoughtShips: ")
        print(arrayBoughtShips)
        let selectedShipsInShop = gameData.defaults.array(forKey: gameData.keys.selected_ship_shop)  as? [Bool] ?? [Bool]()
        print("\nSelectedShipsInShop: ")
        print(selectedShipsInShop)
        let arrayBoughtFireballs = gameData.defaults.array(forKey: gameData.keys.bought_fireballs) as? [Bool] ?? [Bool]()
        print("\nBoughtFireballs: ")
        print(arrayBoughtFireballs)
        let selectedFireballsInShop = gameData.defaults.array(forKey: gameData.keys.selected_fireball_shop) as? [Bool] ?? [Bool]()
        print("\nSelectedFireballsInShop: ")
        print(selectedFireballsInShop)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first?.name == "newGameButton") {
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
                
            } else if (nodesArray.first?.name == "difficultyButton") {
                gameData.saveUserDefaultsChangeGameDifficulty()
                
            } else if (nodesArray.first?.name == "shopButton") {
                gameController?.performSegue(withIdentifier: String(describing: ShopController.self), sender: nil)
            }
        }
    }
    
    func coinManager() {
        
        let coins = gameData.defaults.integer(forKey: gameData.keys.coins)
        self.coinLabelNode?.text = String(coins)
        self.gameData.coins = coins
        self.gameData.saveUserDefaultsCoins()
        
    }
}






































