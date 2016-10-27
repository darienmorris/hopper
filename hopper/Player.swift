//
//  Player.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    
    var animationFrames : [SKTexture]!
    var sprite: SKSpriteNode
    var scene: LevelScene
    var isMoving: Bool = false
    var isAlive: Bool = true
    var positionOnTile: CGPoint = CGPoint(x: 0, y: 0)
    
    init(scene: LevelScene) {

        sprite = SKSpriteNode(imageNamed:"idle-0")
        
        // a lower collision size is more forgiving for players
        let collisionSize: CGFloat = 0.85
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: CGSize(width: sprite.size.width * collisionSize, height: sprite.size.height * collisionSize))
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = BodyType.player.rawValue
        sprite.physicsBody?.contactTestBitMask = BodyType.spinner.rawValue
        sprite.physicsBody?.collisionBitMask = 0
        self.scene = scene
        self.initAnimation();
        self.startAnimation();
        
        
    }
    
    func setPosition(_ x: CGFloat, y: CGFloat) {
        sprite.position = CGPoint(x: x, y: y)

    }
    
    func addToScene(_ scene: SKScene, x: CGFloat, y: CGFloat) {
        setPosition(x, y:y + sprite.size.height / 2)
        sprite.name = "Darien"
        sprite.zPosition = 10
        scene.addChild(sprite)
        positionOnTile = sprite.position
    }
    
    func moveForward() {
        if isMoving || !isAlive {
            return
        }
        
        if let nextTile = scene.getNextTile() {
            let jumpHeight: CGFloat = 15
            let jumpDuration = 0.15
            
            isMoving = true
        
            self.scene.moveCamera(nextTile.position, speed: jumpDuration)
            
            
            let actionMoveX = SKAction.moveBy(x: nextTile.position.x - sprite.position.x, y: 0, duration: jumpDuration)
            
            // Increases jump height based on whether the X or Y difference is greater
            let midPointY:CGFloat = max(nextTile.position.y - sprite.position.y + jumpHeight + sprite.size.height / 2, (nextTile.position.x - sprite.position.x) * 0.15 + jumpHeight)
            
            let actionMoveUpY = SKAction.moveBy(x: 0, y: midPointY, duration: jumpDuration/2)
            actionMoveUpY.timingMode = SKActionTimingMode.easeOut
            
            let actionMoveDownY = SKAction.moveBy(x: 0, y: nextTile.position.y - sprite.position.y - midPointY + sprite.size.height / 2, duration: jumpDuration/2)
            actionMoveDownY.timingMode = SKActionTimingMode.easeIn
            
            let actionMoveComplete = SKAction.run({self.moveComplete()})
            
            sprite.run(actionMoveX)
            sprite.run(SKAction.sequence([actionMoveUpY, actionMoveDownY, actionMoveComplete]))
        }
    }
 
    func moveComplete() {
        isMoving = false
        scene.setNextTile()
        scene.checkForVictory()
        positionOnTile = sprite.position
    }
    
    func die() {
        isAlive = false
        stopMoving()
        sprite.color = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha:0.25)
        sprite.colorBlendFactor = 0.25;
    }
    
    func stopMoving() {
        sprite.removeAllActions()
    }
    
    func bounce() {
        isMoving = true
        let jumpDuration = 0.25
        let moveUp = SKAction.moveTo(y: sprite.position.y + 30, duration: jumpDuration / 2)
        moveUp.timingMode = .easeOut
         
        let moveDown = SKAction.moveTo(y: positionOnTile.y, duration: jumpDuration / 2)
        moveDown.timingMode = .easeIn
        
        let moveUpComplete = SKAction.run({self.moveUpComplete()})
        
        sprite.run(SKAction.sequence([moveUp, moveDown, moveUpComplete]))
    }
    
    func moveUp() {
        if isMoving || !isAlive {
            return
        }
        
        isMoving = true
        let jumpDuration = 0.32
        let moveUp = SKAction.moveTo(y: sprite.position.y + 100, duration: jumpDuration / 2)
        moveUp.timingMode = .easeOut
        
        let moveDown = SKAction.moveTo(y: sprite.position.y, duration: jumpDuration / 2)
        moveDown.timingMode = .easeIn
        
        let moveUpComplete = SKAction.run({self.moveUpComplete()})
        
        sprite.run(SKAction.sequence([moveUp, moveDown, moveUpComplete]))
    }
    
    func moveUpComplete() {
        isMoving = false
    }
    
    func initAnimation() {
        let animatedAtlas = SKTextureAtlas(named: "atlas-player")
        var frames = [SKTexture]()
        
        let numImages = animatedAtlas.textureNames.count
        for i in 0..<numImages {
            let textureName = "idle-\(i)"
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
                   withKey:"playerIdleAnimation")
    }
}
