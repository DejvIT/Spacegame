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
    
    weak var gameController: GameViewController?
    
    var gameData = GameData.shared
    var fireballs:[Fireball]? = []
    var ship:String?
    
    var SCREEN_WIDTH = UIScreen.main.bounds.width
    var SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    var starfield:SKEmitterNode?
    var player:SKSpriteNode?
    var playerAlive: Bool = true
    var boss: Enemy?
    var engineAnimation: SKEmitterNode?
    
    var coinLabelNode:SKLabelNode?
    var seconds:Int = 0
    var shots:Int = 0
    var coins:Int = 0 {
        didSet {
            coinLabelNode?.text = "Score: \(coins)"
            coinLabelNode?.zPosition = 1
        }
    }
    
    var spawnTimer:Timer?
    var enemySpeedTimer:Timer?
    var bossTimer: Timer?
    var bossLaunchFireballTimer: Timer?
    var gameTimer: Timer?
    
    var enemySpeed:Double = 4.0
    var bossIncoming: Bool = false
    
    let photonFireballCategory:UInt32 = 0x1 << 0    //1
    let enemyCategory:UInt32 = 0x1 << 1             //2
    let bossFireballCategory:UInt32 = 0x1 << 2      //4
    let playerCategory:UInt32 = 0x1 << 3            //8
    
    var livesArray:[SKSpriteNode]?
    var gameDifficulty:Int?
    var endButton:SKSpriteNode?
    var spaceshipEngineSound:SKAudioNode!
    
    /**
     Initialization method:
     All initial animations, music, timers and sprite kits are set up here.
     **/
    override func didMove(to view: SKView) {
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addSecond), userInfo: nil, repeats: true)
        
        if let musicURL = Bundle.main.url(forResource: "spaceship-engine", withExtension: ".mp3") {
            spaceshipEngineSound = SKAudioNode(url: musicURL)
            addChild(spaceshipEngineSound)
        }
        
        self.backgroundColor = backgroundColorCustom
        fetchPlayableFireballs()
        
        gameDifficulty = gameData.defaults.integer(forKey: gameData.keys.game_difficulty)
        if gameDifficulty == 1 {
            endButton = SKSpriteNode(imageNamed: "skull-btn")
            endButton?.size = CGSize(width: 40, height: 50)
            endButton?.position = CGPoint(x: self.frame.size.width - (endButton?.size.width)!,
                                   y: self.frame.size.height - 50)
            self.addChild(endButton!)
        } else {
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
        
        player?.physicsBody = SKPhysicsBody(texture: (player?.texture)!, size: CGSize(width: (player?.size.width)!, height: (player?.size.height)!))
        player?.physicsBody?.isDynamic = true
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.contactTestBitMask = bossFireballCategory
        player?.physicsBody?.collisionBitMask = 0
        
        self.addChild(player!)
        
        engineAnimation = SKEmitterNode(fileNamed: "Engine")
        engineAnimation?.position = CGPoint(x: (player?.position.x)!, y: (player?.position.y)! - (player?.size.height)! / 3.5)
        self.addChild(engineAnimation!)
        
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
        
        if gameDifficulty != 1 {
            
            enemySpeedTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(speedUpEnemy), userInfo: nil, repeats: true)
            bossTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(trySpawnBoss), userInfo: nil, repeats: true)
        }
        
    }
    
    /**
     This method notify when button is pressed.
     This button finish game and jump to menu.
     **/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if (nodesArray.first == endButton) {
                
                self.gameOver()
            }
        }
    }
    
    /**
     At the beginning of the every game, the amounts of lives are assigned to player according to game difficulty.
     **/
    func addLives() {
        
        livesArray = [SKSpriteNode]()
        
        if gameDifficulty == 2 {
            
            for live in 1 ... 3 {
                let liveNode = SKSpriteNode(imageNamed: "heart")
                liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width,
                                            y: self.frame.size.height - 50)
                liveNode.size = CGSize(width: 35, height: 35)
                self.addChild(liveNode)
                livesArray?.append(liveNode)
            }
        } else if gameDifficulty == 3 {
            
            let liveNode = SKSpriteNode(imageNamed: "heart")
            liveNode.position = CGPoint(x: self.frame.size.width - liveNode.size.width,
                                        y: self.frame.size.height - 50)
            liveNode.size = CGSize(width: 35, height: 35)
            self.addChild(liveNode)
            livesArray?.append(liveNode)
            
        }
        
    }
    
    /**
     Selector is called regularly according to its timer and speed up game.
     **/
    @objc func speedUpEnemy() {
        
        if enemySpeed > 0.5 {
            enemySpeed -= 0.05 * Double(gameDifficulty!)
        }
    }
    
    /**
     Selector manage time
     **/
    @objc func addSecond() {
        seconds += 1
    }
    
    /**
     This method controls whole logic about an enemies.
     Their behaviour, appearence and animations.
     Detects when enemy survive the player and player lose a piece of life.
     Spawn bosses instead of common enemy when its time.
     **/
    @objc func addEnemy() {
        
        var possibleEnemies = [Enemy]()
        var position: CGFloat
        var animationDuration: TimeInterval
        
        if bossIncoming {
            
            possibleEnemies = Enemy.fetchBosses()
            position = CGFloat(Int(SCREEN_WIDTH) / 2)
            animationDuration = 10
            
            enemySpeedTimer?.invalidate()
            spawnTimer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                
                self.bossIncoming = false
                self.boss = nil
                
                self.spawnTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.addEnemy), userInfo: nil, repeats: true)
                self.bossLaunchFireballTimer?.invalidate()
                
                if self.gameDifficulty != 1 {
                    self.enemySpeedTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.speedUpEnemy), userInfo: nil, repeats: true)
                }
            }
            
        } else {
            
            possibleEnemies = Enemy.fetchEnemies()
            animationDuration = enemySpeed
        }
        
        let randomEnemyPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(SCREEN_WIDTH))
        position = CGFloat(randomEnemyPosition.nextInt())
        let randomIndex = arc4random_uniform(UInt32(possibleEnemies.count))
        let enemy = possibleEnemies[Int(randomIndex)]
        
        enemy.position = CGPoint(x: position, y: self.frame.size.height + enemy.size.height)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: (enemy.size))
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = photonFireballCategory
        enemy.physicsBody?.collisionBitMask = 0
        
        self.addChild(enemy)
        
        if bossIncoming {
            self.boss = enemy
            
            self.run(SKAction.playSoundFileNamed("boss-incoming.mp3", waitForCompletion: false))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                
                self.bossLaunchFireballTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.launchBossFireball), userInfo: nil, repeats: true)
            }
        }
        
        var actionArray = [SKAction]()
        
        if bossIncoming {
            
            actionArray.append(SKAction.move(to: CGPoint(x: CGFloat(arc4random_uniform(UInt32(SCREEN_WIDTH))), y: -(enemy.size.height)), duration: animationDuration))
        } else {
            
            actionArray.append(SKAction.move(to: CGPoint(x: position, y: -(enemy.size.height)), duration: animationDuration))
        }
        
        if gameDifficulty != 1 {
            actionArray.append(SKAction.run {
                
                if ((self.livesArray?.count)! > 0) {
                    let liveNode = self.livesArray?.first
                    liveNode!.removeFromParent()
                    self.livesArray?.removeFirst()
                    
                } else if (self.livesArray?.count == 0) {
                    
                    self.gameOver()
                }
                
            })
        }
        
        actionArray.append(SKAction.removeFromParent())
        
        enemy.run(SKAction.sequence(actionArray))
    }
    
    /**
     Touching/clicking on display represent the behaviour of player, where to go and where to shoot.
     **/
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if playerAlive {
            
            // position of the ship to coordinate of x of the touched point
            if let touch = touches.first {
                let position = touch.location(in: self)
                player?.position = CGPoint(x: position.x, y: (player?.position.y)!)
                engineAnimation?.position = CGPoint(x: (player?.position.x)!, y: (player?.position.y)! - (player?.size.height)! / 3.5)
            }
            
            launchFireball()
            shots += 1
        }
    }
    
    /**
     When player runs out of health, game over scene appear.
     **/
    func gameOver() {
        
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
        let gameOverScene = SKScene(fileNamed: "GameOverScene") as! GameOverScene
        self.enemySpeedTimer?.invalidate()
        self.spawnTimer?.invalidate()
        gameOverScene.coins = self.coins
        gameOverScene.shots = self.shots
        gameOverScene.seconds = self.seconds
        gameOverScene.gameDifficulty = self.gameDifficulty!
        gameOverScene.gameController = self.gameController
        self.view?.presentScene(gameOverScene, transition:transition)
    }
    
    /**
     Fetch all fireballs player selected in the shop.
     **/
    func fetchPlayableFireballs() {
        let fetchedAll = Fireball.fetchFireballs()
        
        var i:Int = 0
        while i < fetchedAll.count {
            if fetchedAll[i].selectedFireball {
                fireballs?.append(fetchedAll[i])
            }
            
            i += 1
        }
    }
    
    /**
     This selector controls appearance of fireballs sprite node its animation, music and physics body.
     This selector is called by timer.
     **/
    @objc func launchBossFireball() {
        
        if boss != nil && playerAlive {
            
            self.run(SKAction.playSoundFileNamed("fireball-boss.mp3", waitForCompletion: false))
            
            let fireballNode = SKSpriteNode(imageNamed: "fireball18-blackhole")
            fireballNode.size = CGSize(width: 70, height: 70)
            fireballNode.position = (self.boss?.position)!
            fireballNode.position.y -= 50
            
            fireballNode.physicsBody = SKPhysicsBody(circleOfRadius: max(fireballNode.size.width / 10, fireballNode.size.height / 10))
            fireballNode.physicsBody?.isDynamic = true
            
            fireballNode.physicsBody?.categoryBitMask = bossFireballCategory
            fireballNode.physicsBody?.contactTestBitMask = (playerCategory | photonFireballCategory)
            fireballNode.physicsBody?.collisionBitMask = 0
            fireballNode.physicsBody?.usesPreciseCollisionDetection = true
            
            self.addChild(fireballNode)
            
            let animationDuration:TimeInterval = 1.5
            
            var actionArray = [SKAction]()
            
            actionArray.append(SKAction.move(to: CGPoint(x: (self.player?.position.x)!, y: -self.frame.size.height), duration: animationDuration))
            actionArray.append(SKAction.removeFromParent())
            
            fireballNode.run(SKAction.sequence(actionArray))
        }
    }
    
    /**
     This method controlls players fireballs, its appearance, position, music and physics body.
     When touch is detected this method is called.
     **/
    func launchFireball() {
        self.run(SKAction.playSoundFileNamed("plasma-gun.mp3", waitForCompletion: false))
        
        let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: (fireballs?.count)!)
        
        let fireballNode = SKSpriteNode(imageNamed: fireballs![randomIndex].name)
        fireballNode.size = CGSize(width: 45, height: 45)
        fireballNode.position = (player?.position)!
        fireballNode.position.y += 40
        
        fireballNode.physicsBody = SKPhysicsBody(circleOfRadius: max(fireballNode.size.width / 2, fireballNode.size.height / 2))
        fireballNode.physicsBody?.isDynamic = true
        
        fireballNode.physicsBody?.categoryBitMask = photonFireballCategory
        fireballNode.physicsBody?.contactTestBitMask = (enemyCategory | bossFireballCategory)
        fireballNode.physicsBody?.collisionBitMask = 0
        fireballNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(fireballNode)
        
        let animationDuration:TimeInterval = 0.5
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: (player?.position.x)!, y: self.frame.size.height - 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        fireballNode.run(SKAction.sequence(actionArray))
    }
    
    /**
     This method controls contact of several physics bodies.
     According to contact, the competent method is called.
     **/
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
        
        if((firstBody.categoryBitMask & photonFireballCategory) == 1 && (secondBody.categoryBitMask & enemyCategory) == 2) {
            fireballDidCollideWithEnemy(fireballNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! Enemy)
        } else if ((firstBody.categoryBitMask & bossFireballCategory) == 4 && (secondBody.categoryBitMask & playerCategory) == 8) {
            fireballDidCollideWithPlayer(fireballNode: firstBody.node as! SKSpriteNode, playerNode: secondBody.node as! SKSpriteNode)
        } else if ((firstBody.categoryBitMask & photonFireballCategory) == 1 && (secondBody.categoryBitMask & bossFireballCategory) == 4) {
            fireballsCollideEachOther(fireballNodeA: firstBody.node as! SKSpriteNode, fireballNodeB: secondBody.node as! SKSpriteNode)
        }
    }
    
    /**
     Logic of contact between players fireball and enemy.
     **/
    func fireballDidCollideWithEnemy(fireballNode: SKSpriteNode, enemyNode: Enemy) {
        
        enemyNode.health -= 1
        fireballNode.removeFromParent()
        
        if enemyNode.health == 0 {
            
            if enemyNode.boss {
                
                boss = nil
                coins += gameDifficulty! * 10
                let skullSmoke = SKEmitterNode(fileNamed: "Magic-skull")!
                skullSmoke.position = enemyNode.position
                self.addChild(skullSmoke)
                self.run(SKAction.playSoundFileNamed("monsterkill-sound.mp3", waitForCompletion: false))
                self.run(SKAction.wait(forDuration: 2)) {
                    skullSmoke.removeFromParent()
                }
            } else {
                
                let explosion = SKEmitterNode(fileNamed: "Explosion")!
                explosion.position = enemyNode.position
                self.addChild(explosion)
                self.run(SKAction.wait(forDuration: 2)) {
                    explosion.removeFromParent()
                }
                self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
                
                var coin: SKSpriteNode
                
                if gameDifficulty == 3 {
                    coin = SKSpriteNode(imageNamed: "coins-bag")
                } else {
                    coin = SKSpriteNode(imageNamed: "coin")
                }
                
                coin.position = CGPoint(x: enemyNode.position.x, y: enemyNode.position.y)
                coin.size = CGSize(width: 25, height: 45)
                self.addChild(coin)
                let animationDuration:TimeInterval = 0.75
                var actionArray = [SKAction]()
                actionArray.append(SKAction.move(to: CGPoint(x: coin.position.x, y: coin.position.y - self.frame.size.height), duration: animationDuration))
                actionArray.append(SKAction.removeFromParent())
                coin.run(SKAction.sequence(actionArray))
            }
            
            enemyNode.removeFromParent()
            
            
            addCoins()
        } else {
            
            let damage = SKEmitterNode(fileNamed: "Damage")!
            damage.position = CGPoint(x: enemyNode.position.x, y: enemyNode.position.y - (enemyNode.size.height / 2))
            self.addChild(damage)
        }
        
    }
    
    /**
     Logic of contact between boss's fireball and player.
     **/
    func fireballDidCollideWithPlayer(fireballNode: SKSpriteNode, playerNode: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Blackhole-explosion")!
        explosion.position = (player?.position)!
        self.addChild(explosion)
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        fireballNode.removeFromParent()
        
        if ((self.livesArray?.count)! > 0) {
            
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            
            let liveNode = self.livesArray?.first
            liveNode!.removeFromParent()
            self.livesArray?.removeFirst()
            
        } else if (self.livesArray?.count == 0) {
            
            self.run(SKAction.playSoundFileNamed("player-explosion.mp3", waitForCompletion: false))
            playerAlive = false
            
            let playerExplosion1 = SKEmitterNode(fileNamed: "Player-right")
            playerExplosion1?.position = (player?.position)!
            self.addChild(playerExplosion1!)
            self.run(SKAction.wait(forDuration: 2)) {
                playerExplosion1?.removeFromParent()
            }
            engineAnimation?.removeFromParent()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                let playerExplosion2 = SKEmitterNode(fileNamed: "Player-back")
                playerExplosion2?.position = (self.player?.position)!
                self.addChild(playerExplosion2!)
                self.run(SKAction.wait(forDuration: 2)) {
                    playerExplosion2?.removeFromParent()
                }
                
                self.player?.removeFromParent()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                let playerExplosion3 = SKEmitterNode(fileNamed: "Player-left")
                playerExplosion3?.position = (self.player?.position)!
                self.addChild(playerExplosion3!)
                self.run(SKAction.wait(forDuration: 2)) {
                    playerExplosion3?.removeFromParent()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                
                let playerExplosionSmoke = SKEmitterNode(fileNamed: "Player-smoke")
                playerExplosionSmoke?.position = (self.player?.position)!
                self.addChild(playerExplosionSmoke!)
                self.run(SKAction.wait(forDuration: 4)) {
                    playerExplosionSmoke?.removeFromParent()
                    self.gameOver()
                }
            }
        }
    }
    
    /**
     Logic of contact between two fireballs.
     **/
    func fireballsCollideEachOther(fireballNodeA: SKSpriteNode, fireballNodeB: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Plasma-explosion")!
        explosion.position = fireballNodeA.position
        self.addChild(explosion)
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        self.run(SKAction.playSoundFileNamed("plasma-explosion.mp3", waitForCompletion: false))
        fireballNodeA.removeFromParent()
        fireballNodeB.removeFromParent()
    }
    
    /**
     Method for adding coins according to game difficulty.
     **/
    func addCoins() {
        
        switch gameDifficulty {
        case 1:
            self.coins += 1
        case 2:
            self.coins += 5
        case 3:
            self.coins += 10
        default:
            break
        }
    }
    
    /**
     This selector is called regularly by timer and checks if the boss can be spawn.
     **/
    @objc func trySpawnBoss() {
        
        if !bossIncoming && boss == nil {
            
            if gameDifficulty == 2 {
                
                if coins % 150 == 0 && coins != 0 {
                    bossIncoming = true
                    enemySpeed += 1.8
                }
            } else {
                
                if coins % 200 == 0 && coins != 0 {
                    bossIncoming = true
                    enemySpeed += 1.2
                }
            }
        }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



































