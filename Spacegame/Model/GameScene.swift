//
//  GameScene.swift
//  Spacegame
//
//  Created by MaestroDavo on 1.2.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit
import GameplayKit

var backgroundColorCustom = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameData = GameData.shared
    var fireballs:[Fireball]? = []
    var ship:String?
    
    var SCREEN_WIDTH = UIScreen.main.bounds.width
    var SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    var starfield:SKEmitterNode?
    var player:SKSpriteNode?
    
    var coinLabelNode:SKLabelNode?
    var coins:Int = 0 {
        didSet {
            coinLabelNode?.text = "Score: \(coins)"
            coinLabelNode?.zPosition = 1
        }
    }
    
    var spawnTimer:Timer?
    var enemySpeedTimer:Timer?
    
    var possibleEnemies = ["devil", "asteroid", "asteroid2", "martian"]
    var enemySpeed:Double = 2.0
    
    let enemyCategory:UInt32 = 0x1 << 1
    let photonFireballCategory:UInt32 = 0x1 << 0
    
    var livesArray:[SKSpriteNode]?
    
    var gameDifficulty:Int?
    
    override func didMove(to view: SKView) {
        
        
        
        self.backgroundColor = backgroundColorCustom
        fetchPlayableFireballs()
        
        gameDifficulty = gameData.defaults.integer(forKey: gameData.keys.game_difficulty)
        if gameDifficulty != 1 {
            addLives()
        }
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield?.position = CGPoint(x: 0, y: Int(SCREEN_HEIGHT))
        starfield?.advanceSimulationTime(10)
        self.addChild(starfield!)
        
        starfield?.zPosition = -1
        
        ship = gameData.defaults.string(forKey: gameData.keys.play_ship)
        player = SKSpriteNode(imageNamed: ship!)
        player?.size = CGSize(width: 130, height: 130)
        player?.position = CGPoint(x: self.frame.size.width / 2, y: (player?.size.height)! / 2 + 20)
        self.addChild(player!)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        coinLabelNode = SKLabelNode(text: "Score: 0")
        coinLabelNode?.position = CGPoint(x: 80, y: self.frame.size.height - 60)
        coinLabelNode?.fontName = "AmericanTypewriter-Bold"
        coinLabelNode?.fontSize = 28
        coinLabelNode?.fontColor = UIColor.white
        coins = 0
        
        self.addChild(coinLabelNode!)
        
        
        
        spawnTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
        enemySpeedTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(speedUpEnemy), userInfo: nil, repeats: true)
        
    }
    
    func addLives() {
        
        livesArray = [SKSpriteNode]()
        
        //TODO zivoty rozne pre normal a chinese game
        
        for live in 1 ... 3 {
            let liveNode = SKSpriteNode(imageNamed: "heart")
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width,
                                        y: self.frame.size.height - 50)
            liveNode.size = CGSize(width: 35, height: 35)
            self.addChild(liveNode)
            livesArray?.append(liveNode)
        }
        
    }
    
    @objc func speedUpEnemy() {
        
        //TODO rychlost pre difficulty rozna
        enemySpeed += 0.05
    }
    
    @objc func addEnemy() {
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleEnemies) as! [String]
        
        let enemy = SKSpriteNode(imageNamed: possibleEnemies[0])
        let randomEnemyPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(SCREEN_WIDTH))
        let position = CGFloat(randomEnemyPosition.nextInt())
        
        enemy.position = CGPoint(x: position, y: self.frame.size.height + enemy.size.height)
        enemy.size = CGSize(width: 80, height: 65)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = photonFireballCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        let animationDuration:TimeInterval = enemySpeed
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -enemy.size.height), duration: animationDuration))
        
        if gameDifficulty != 1 {
            actionArray.append(SKAction.run {
                
                if ((self.livesArray?.count)! > 0) {
                    let liveNode = self.livesArray?.first
                    liveNode!.removeFromParent()
                    self.livesArray?.removeFirst()
                    
                } else if (self.livesArray?.count == 0) {
                    
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    let gameScene = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                    gameScene.coins = self.coins
                    self.view?.presentScene(gameScene, transition:transition)
                }
                
            })
        }
        
        actionArray.append(SKAction.removeFromParent())
        
        enemy.run(SKAction.sequence(actionArray))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // position of the ship to coordinate of x of the touched point
        if let touch = touches.first {
            let position = touch.location(in: self)
            player?.position = CGPoint(x: position.x, y: (player?.position.y)!)
        }
        
        launchFireball()
        
    }
    
    func fetchPlayableFireballs() {
        let fetchedAll = Fireball.fetchFireballs()
        
        var i:Int = 0
        while i < fetchedAll.count {
            if fetchedAll[i].selectedFireball {
                fireballs?.append(fetchedAll[i])
                print(fetchedAll[i].name)
            }
            
            i += 1
        }
    }
    
    func launchFireball() {
        self.run(SKAction.playSoundFileNamed("fireball.mp3", waitForCompletion: false))
        
        let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: (fireballs?.count)!)
        print(randomIndex)
        
        let fireballNode = SKSpriteNode(imageNamed: fireballs![randomIndex].name)
        fireballNode.size = CGSize(width: 45, height: 45)
        fireballNode.position = (player?.position)!
        fireballNode.position.y += 40
        
        fireballNode.physicsBody = SKPhysicsBody(circleOfRadius: fireballNode.size.width / 2)
        fireballNode.physicsBody?.isDynamic = true
        
        fireballNode.physicsBody?.categoryBitMask = photonFireballCategory
        fireballNode.physicsBody?.contactTestBitMask = enemyCategory
        fireballNode.physicsBody?.collisionBitMask = 0
        fireballNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(fireballNode)
        
        let animationDuration:TimeInterval = 0.5
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: (player?.position.x)!, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        fireballNode.run(SKAction.sequence(actionArray))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & photonFireballCategory) != 0 && (secondBody.categoryBitMask & enemyCategory) != 0) {
            fireballDidCollideWithEnemy(fireballNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    func fireballDidCollideWithEnemy(fireballNode: SKSpriteNode, enemyNode: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = enemyNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.position = CGPoint(x: enemyNode.position.x, y: enemyNode.position.y)
        coin.size = CGSize(width: 25, height: 45)
        self.addChild(coin)
        let animationDuration:TimeInterval = 0.75
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: coin.position.x, y: coin.position.y - self.frame.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        coin.run(SKAction.sequence(actionArray))
        
        fireballNode.removeFromParent()
        enemyNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        self.coins += 5
    }
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



































