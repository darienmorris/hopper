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
    
    var animationFrames : [SKTexture]!
    
    override init(scene: LevelScene, sprite: SKSpriteNode) {
        super.init(scene: scene, sprite: sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = BodyType.spinner.rawValue
        sprite.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        sprite.physicsBody?.collisionBitMask = 0
        
        
        let duration: Double = 1.5
        sprite.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveTo(y: self.sprite.position.y - 100, duration:duration), SKAction.moveTo(y: self.sprite.position.y + 100, duration:duration)])))
        
        initAnimation();
        startAnimation();
    }
    
    func initAnimation() {
        let animatedAtlas = SKTextureAtlas(named: "atlas-bat")
        var frames = [SKTexture]()
        
        let numImages = animatedAtlas.textureNames.count
        for i in 0..<numImages {
            let textureName = "bat-\(i)"
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        
        animationFrames = frames
    }
    
    func startAnimation() {
        sprite.run(SKAction.repeatForever(
            SKAction.animate(with: animationFrames,
                timePerFrame: 0.15,
                resize: false,
                restore: true)),
            withKey:"spinnerAnimation")
    }
}
