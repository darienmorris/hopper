//
//  Spinner.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-23.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class Spinner: Enemy {
    
    override init(scene: LevelScene, node: SKNode) {
        super.init(scene: scene, node: node)
        
        
        let duration: Double = 1
        node.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(self.node.position.y - 100, duration:duration), SKAction.moveToY(self.node.position.y + 100, duration:duration)])))
        
        node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-1, duration: 0.25)))
    }
}