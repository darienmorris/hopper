//
//  Spinner.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-23.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class WingMan: Enemy {
    
    var animationFrames : [SKTexture]!
    
    override init(scene: LevelScene, sprite: SKSpriteNode) {
        super.init(scene: scene, sprite: sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = BodyType.wingMan.rawValue
        sprite.physicsBody?.contactTestBitMask = BodyType.player.rawValue
        sprite.physicsBody?.collisionBitMask = 0
        
        
        let speed: Float = 150.0
        let duration: Double = (Double)(Float(self.sprite.position.x) / speed)
        sprite.run(SKAction.repeatForever(SKAction.moveTo(x: -300, duration:duration)))
        
        initAnimation();
        startAnimation();
    }
    
    func initAnimation() {
        let animatedAtlas = SKTextureAtlas(named: "atlas-wing-man")
        var frames = [SKTexture]()
        
        let numImages = animatedAtlas.textureNames.count
        for i in 1..<numImages+1 {
            let textureName = "e-wing-man-\(i)"
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        
        animationFrames = frames
    }
    
    func startAnimation() {
        sprite.run(SKAction.repeatForever(
            SKAction.animate(with: animationFrames,
                             timePerFrame: 0.05,
                             resize: false,
                             restore: true)),
                   withKey:"spinnerAnimation")
    }
}
