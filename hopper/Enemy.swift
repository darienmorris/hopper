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
    
    var node: SKNode
    var scene: LevelScene
    
    init(scene: LevelScene, node: SKNode) {
        self.node = node
        self.scene = scene
        
        
    }
}