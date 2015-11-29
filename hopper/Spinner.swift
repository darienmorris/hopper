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
    
    override init(scene: LevelScene, sprite: SKSpriteNode) {
        super.init(scene: scene, sprite: sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = BodyType.spinner.rawValue
        sprite.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        sprite.physicsBody?.collisionBitMask = 0
        
        
        let duration: Double = 1
        sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(self.sprite.position.y - 100, duration:duration), SKAction.moveToY(self.sprite.position.y + 100, duration:duration)])))
        
        sprite.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-1, duration: 0.25)))
    }
}