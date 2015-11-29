//
//  Player.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy {
    
    var sprite: SKSpriteNode
    var scene: LevelScene
    
    init(scene: LevelScene, sprite: SKSpriteNode) {
        self.sprite = sprite
        self.scene = scene
    }
    
    func pause() {
        self.sprite.removeAllActions()
    }
    
    func resume() {
        
    }
}