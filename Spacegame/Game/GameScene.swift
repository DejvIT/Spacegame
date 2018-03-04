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
    
    var SCREEN_WIDTH = UIScreen.main.bounds.width
    var SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    var starfield:SKEmitterNode!
    var player:SKSpriteNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            scoreLabel.zPosition = 1
        }
    }
    
    var gameTimer:Timer!
    
    var possibleAliens = ["diablik", "alien", "alien2", "alien3"]
    
    let alienCategory:UInt32 = 0x1 << 1
    let photonTorpedoCategory:UInt32 = 0x1 << 0
    
    var livesArray:[SKSpriteNode]!
    
    var difficulty:String = ""
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = backgroundColorCustom
        
        if (difficulty == "Hard") {
            addLives()
        }
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: Int(SCREEN_HEIGHT))
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "vesmirnaLod")
        player.position = CGPoint(x: self.frame.size.width / 2, y: player.size.height / 2 + 20)
        
        self.addChild(player)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: self.frame.size.height - 60)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = UIColor.white
        score = 0
        
        self.addChild(scoreLabel)
        
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAlien), userInfo: nil, repeats: true)
        
    }
    
    func addLives() {
        
        livesArray = [SKSpriteNode]()
        
        for live in 1 ... 3 {
            let liveNode = SKSpriteNode(imageNamed: "heart")
            liveNode.position = CGPoint(x: self.frame.size.width - CGFloat(4 - live) * liveNode.size.width,
                                        y: self.frame.size.height - 50)
            liveNode.size = CGSize(width: 35, height: 35)
            self.addChild(liveNode)
            livesArray.append(liveNode)
        }
        
    }
    
    @objc func addAlien() {
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(SCREEN_WIDTH))
        let position = CGFloat(randomAlienPosition.nextInt())
        
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        //alien.size = CGSize(width: 65, height: 65)
        
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory
        alien.physicsBody?.collisionBitMask = 0
        
        self.addChild(alien)
        
        let animationDuration:TimeInterval = 4
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        
        if (difficulty == "Hard") {
            actionArray.append(SKAction.run {
                
                if (self.livesArray.count > 0) {
                    let liveNode = self.livesArray.first
                    liveNode!.removeFromParent()
                    self.livesArray.removeFirst()
                    
                } else if (self.livesArray.count == 0) {
                    
                    let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.5)
                    let gameScene = SKScene(fileNamed: "GameOverScene") as! GameOverScene
                    gameScene.score = self.score
                    self.view?.presentScene(gameScene, transition:transition)
                }
                
            })
        }
        
        actionArray.append(SKAction.removeFromParent())
        
        alien.run(SKAction.sequence(actionArray))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // position of the ship to coordinate of x of the touched point
        if let touch = touches.first {
            let position = touch.location(in: self)
            player.position = CGPoint(x: position.x, y: player.position.y)
        }
        
        fireTorpedo()
        
    }
    
    func fireTorpedo() {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 40
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = 0.5
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
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
        
        if((firstBody.categoryBitMask & photonTorpedoCategory) != 0 && (secondBody.categoryBitMask & alienCategory) != 0) {
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 5
    }
    
    
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}



































