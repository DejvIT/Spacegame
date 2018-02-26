//
//  GameOverScene.swift
//  Spacegame
//
//  Created by MaestroDavo on 2.2.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var stars:SKEmitterNode!
    
    var score:Int = 0
    
    var gameOver:SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        stars = self.childNode(withName: "stars") as! SKEmitterNode
        stars.advanceSimulationTime(10)
        
        print(score)
        
    }
}
