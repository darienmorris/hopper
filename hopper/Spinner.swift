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
        
        
        let duration: Double = 1
        sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(self.sprite.position.y - 100, duration:duration), SKAction.moveToY(self.sprite.position.y + 100, duration:duration)])))
        
        //sprite.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-1, duration: 0.25)))
        
        initAnimation();
        startAnimation();
    }
    
    func initAnimation() {
        let animatedAtlas = SKTextureAtlas(named: "atlas-spinner")
        var frames = [SKTexture]()
        
        let numImages = animatedAtlas.textureNames.count
        print("Num images: \(numImages)")
        for var i=1; i<=numImages; i++ {
            let textureName = "e-spinner-\(i)"
            frames.append(animatedAtlas.textureNamed(textureName))
        }
        
        animationFrames = frames
    }
    
    func startAnimation() {
        print("animationFrames \(animationFrames.count)")
        //This is our general runAction method to make our bear walk.
        sprite.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(animationFrames,
                timePerFrame: 0.05,
                resize: false,
                restore: true)),
            withKey:"spinnerAnimation")
    }
}