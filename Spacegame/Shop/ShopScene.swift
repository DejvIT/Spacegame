//
//  ShopScene.swift
//  Spacegame
//
//  Created by MaestroDavo on 4.3.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit

class ShopScene: SKScene {
    
    var starfield:SKEmitterNode!
    
    var menuButtonNode:SKSpriteNode!
    var coinLabelNode:SKLabelNode!
    var coins:Int = 0
    
    override func didMove(to view: SKView) {
        
        starfield = self.childNode(withName: "starfield") as! SKEmitterNode
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        
        menuButtonNode = self.childNode(withName: "menuButton") as! SKSpriteNode
        
        coinLabelNode = self.childNode(withName: "coinLabel") as! SKLabelNode
        coinLabelNode.text = "\(coins)"
    }
}
