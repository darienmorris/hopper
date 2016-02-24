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
    
    var sprite: SKSpriteNode
    var scene: LevelScene
    var isMoving: Bool = false
    var isAlive: Bool = true
    
    init(scene: LevelScene) {

        sprite = SKSpriteNode(imageNamed:"player-default")
        
        // a lower collision size is more forgiving for players
        let collisionSize: CGFloat = 0.85
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: CGSize(width: sprite.size.width * collisionSize, height: sprite.size.height * collisionSize))
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = BodyType.player.rawValue
        sprite.physicsBody?.contactTestBitMask = BodyType.spinner.rawValue
        sprite.physicsBody?.collisionBitMask = 0
        
        self.scene = scene
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        sprite.position = CGPoint(x: x, y: y)

    }
    
    func addToScene(scene: SKScene, x: CGFloat, y: CGFloat) {
        setPosition(x, y:y + sprite.size.height / 2)
        sprite.name = "Darien"
        sprite.zPosition = 10
        scene.addChild(sprite)
    }
    
    func moveForward() {
        if isMoving || !isAlive {
            return;
        }
        
        if let nextTile = scene.getNextTile() {
            let jumpHeight: CGFloat = 20
            let jumpDuration = 0.20
            
            isMoving = true
        
            self.scene.moveCamera(nextTile.position, speed: jumpDuration)
            
            
            let actionMoveX = SKAction.moveByX(nextTile.position.x - sprite.position.x, y: 0, duration: jumpDuration)
            
            // Increases jump height based on whether the X or Y difference is greater
            let midPointY:CGFloat = max(nextTile.position.y - sprite.position.y + jumpHeight + sprite.size.height / 2, (nextTile.position.x - sprite.position.x) * 0.15 + jumpHeight)
            
            let actionMoveUpY = SKAction.moveByX(0, y: midPointY, duration: jumpDuration/2)
            actionMoveUpY.timingMode = SKActionTimingMode.EaseOut
            
            let actionMoveDownY = SKAction.moveByX(0, y: nextTile.position.y - sprite.position.y - midPointY + sprite.size.height / 2, duration: jumpDuration/2)
            actionMoveDownY.timingMode = SKActionTimingMode.EaseIn
            
            let actionMoveComplete = SKAction.runBlock({self.moveComplete()})
            
            sprite.runAction(actionMoveX)
            sprite.runAction(SKAction.sequence([actionMoveUpY, actionMoveDownY, actionMoveComplete]))
        }
    }
 
    func moveComplete() {
        isMoving = false
        scene.setNextTile()
        scene.checkForVictory()
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
    
    func moveUp() {
        if isMoving || !isAlive {
            return;
        }
        
        isMoving = true
        let jumpDuration = 0.32
        let moveUp = SKAction.moveToY(sprite.position.y + 100, duration: jumpDuration / 2)
        moveUp.timingMode = .EaseOut
        
        let moveDown = SKAction.moveToY(sprite.position.y, duration: jumpDuration / 2)
        moveDown.timingMode = .EaseIn
        
        let moveUpComplete = SKAction.runBlock({self.moveUpComplete()})
        
        sprite.runAction(SKAction.sequence([moveUp, moveDown, moveUpComplete]))
    }
    
    func moveUpComplete() {
        isMoving = false
    }
}