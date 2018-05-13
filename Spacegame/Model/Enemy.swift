//
//  Enemy.swift
//  Spacegame
//
//  Created by MaestroDavo on 5.5.18.
//  Copyright © 2018 MaestroDavo. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    var health: Int
    var boss: Bool
    
    /**
     Constructor of enemy's class
     **/
    init(name: String, health: Int, size: CGSize, boss: Bool) {
        
        self.health = health
        self.boss = boss
        let enemyTexture = SKTexture(imageNamed: name)
        super.init(texture: enemyTexture, color: UIColor.clear, size: size)
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Fetch common enemies
     **/
    static func fetchEnemies() -> [Enemy] {

        return [
            Enemy(name: "devil", health: 1, size: CGSize(width: 75, height: 75), boss: false),
            Enemy(name: "asteroid", health: 1, size: CGSize(width: 60, height: 40), boss: false),
            Enemy(name: "asteroid2", health: 1, size: CGSize(width: 60, height: 40), boss: false),
            Enemy(name: "martian", health: 1, size: CGSize(width: 60, height: 40), boss: false),
        ]
    }
    
    /**
     Fetch bosses
     **/
    static func fetchBosses() -> [Enemy] {
        
        return [
            Enemy(name: "demon", health: 20, size: CGSize(width: 150, height: 150), boss: true),
            Enemy(name: "skull", health: 15, size: CGSize(width: 120, height: 120), boss: true)
        ]
    }
}
