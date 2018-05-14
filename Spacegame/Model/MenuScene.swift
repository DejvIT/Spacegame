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
    
    weak var bestScoreLabelNode:SKLabelNode?
    weak var mostShotsLabelNode:SKLabelNode?
    weak var longestGameLabelNode:SKLabelNode?
    
    var backgroundMusic:SKAudioNode!
    
    /**
     Initialization of menu, loading saved user data or initialization data for first app's run.
     **/
    override func didMove(to view: SKView) {
        
        if let musicURL = Bundle.main.url(forResource: "main_menu_music", withExtension: ".mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        //gameData.removeAllUserDefaults()
        //gameData.addCoins(amount: 60000)
        
        starfield = self.childNode(withName: "starfield") as? SKEmitterNode
        starfield?.advanceSimulationTime(10)
        starfield?.zPosition = -1
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        difficultyButtonNode = self.childNode(withName: "difficultyButton") as? SKSpriteNode
        difficultyLabelNode = self.childNode(withName: "difficultyLabel") as? SKLabelNode
        
        bestScoreLabelNode = self.childNode(withName: "bestScoreLabel") as? SKLabelNode
        mostShotsLabelNode = self.childNode(withName: "mostShotsLabel") as? SKLabelNode
        longestGameLabelNode = self.childNode(withName: "longestGameLabel") as? SKLabelNode
        
        if !gameData.defaults.bool(forKey: gameData.keys.first_app_run_done) {
            
            gameData.setInitialStatistics()
            gameData.initialShopSettings(index: 0)
            gameData.saveUserDefaultsPlayShip()
            gameData.saveUserDefaultsSelectedShipInShop(index: 0, bool: true)
            gameData.saveUserDefaultsFirstAppRunDone(bool: true)
            gameData.saveUserDefaultsChangeGameDifficulty()
        }

        getDifficulty()
        
        coinLabelNode = self.childNode(withName: "coinLabel") as? SKLabelNode
        coinManager()
        
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
    
    /**
     This method controls what kind of button user touched/clicked.
     Then the competent view/behaviour is called.
     **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first?.name == "newGameButton") {
                
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                gameScene.gameController = self.gameController
                self.view?.presentScene(gameScene, transition: transition)
                
            } else if (nodesArray.first?.name == "difficultyButton") {
                gameData.saveUserDefaultsChangeGameDifficulty()
                getDifficulty()
                
            } else if (nodesArray.first?.name == "shopButton") {
                gameController?.performSegue(withIdentifier: String(describing: ShopController.self), sender: nil)
            }
        }
    }
    
    /**
     This method load the amount of coins from device's memory.
     **/
    func coinManager() {
        
        let coins = gameData.defaults.integer(forKey: gameData.keys.coins)
        self.coinLabelNode?.text = String(coins)
        
    }
    
    /**
     This method controls difficulty label.
     First load saved game difficulty and then the competent string is represented.
     This method also manage game settings for every difficulty level.
     **/
    func getDifficulty() {
        
        let arrayScore = gameData.defaults.array(forKey: gameData.keys.best_score)  as? [Int] ?? [Int]()
        let arrayShots = gameData.defaults.array(forKey: gameData.keys.most_shots)  as? [Int] ?? [Int]()
        let arrayTime = gameData.defaults.array(forKey: gameData.keys.longest_game)  as? [Int] ?? [Int]()
        
        if gameData.defaults.integer(forKey: gameData.keys.game_difficulty) == 3 {
            
            difficultyLabelNode?.text = "Chinese"
            bestScoreLabelNode?.text = String(arrayScore[2])
            mostShotsLabelNode?.text = String(arrayShots[2])
            longestGameLabelNode?.text = getTimeFromSeconds(seconds: arrayTime[2])
        } else if gameData.defaults.integer(forKey: gameData.keys.game_difficulty) == 2 {
            
            difficultyLabelNode?.text = "Normal"
            bestScoreLabelNode?.text = String(arrayScore[1])
            mostShotsLabelNode?.text = String(arrayShots[1])
            longestGameLabelNode?.text = getTimeFromSeconds(seconds: arrayTime[1])
        } else {
            
            difficultyLabelNode?.text = "Fun"
            bestScoreLabelNode?.text = String(arrayScore[0])
            mostShotsLabelNode?.text = String(arrayShots[0])
            longestGameLabelNode?.text = getTimeFromSeconds(seconds: arrayTime[0])
        }
    }
    
    /**
     This method calculate time from seconds
     **/
    func getTimeFromSeconds(seconds: Int) -> String {
        var time:String = "0:0"
        var mins = Double(seconds) / Double(60)
        mins.round(.towardZero)
        let sec = seconds % 60
        
        if mins < 10 && sec < 10 {
            time = "0" + String(Int(mins)) + " : " + "0" + String(sec)
        } else if mins > 9 && sec < 10 {
            time = String(Int(mins)) + " : " + "0" + String(sec)
        } else if mins < 10 && sec > 9 {
            time = "0" + String(Int(mins)) + " : " + String(sec)
        } else {
            time = String(Int(mins)) + " : " + String(sec)
        }
        
        print("Time: " + String(seconds) + " " + String(mins) + " " + String(sec))
        return time
    }
}






































