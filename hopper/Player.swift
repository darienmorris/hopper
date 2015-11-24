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
    
    init(scene: LevelScene) {
        self.sprite = SKSpriteNode(imageNamed:"c-player-1")
        self.scene = scene
    }
    
    func setPosition(x: CGFloat, y: CGFloat) {
        self.sprite.position = CGPoint(x: x, y: y)

    }
    
    func addToScene(scene: SKScene, x: CGFloat, y: CGFloat) {
        setPosition(x, y:y)
        self.sprite.name = "Darien"
        self.sprite.zPosition = 10
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        scene.addChild(self.sprite)
    }
    
    func moveForward() {
        if isMoving {
            return;
        }
        
        
        
        if let nextTile = scene.getNextTile() {
            isMoving = true
        

            let jumpHeight: CGFloat = 20
            let jumpDuration = 0.25
            
            self.scene.moveCamera(nextTile.position, speed: jumpDuration)
            let actionMoveX = SKAction.moveByX(nextTile.position.x - self.sprite.position.x, y: 0, duration: jumpDuration)
            
            let midPointY:CGFloat = max(nextTile.position.y - self.sprite.position.y + jumpHeight , (nextTile.position.x - self.sprite.position.x) * 0.15 + jumpHeight)
            
            let actionMoveUpY = SKAction.moveByX(0, y: midPointY, duration: jumpDuration/2)
            actionMoveUpY.timingMode = SKActionTimingMode.EaseOut
            
            let actionMoveDownY = SKAction.moveByX(0, y: nextTile.position.y - self.sprite.position.y - midPointY, duration: jumpDuration/2)
            actionMoveDownY.timingMode = SKActionTimingMode.EaseIn
            
            let actionMoveComplete = SKAction.runBlock({self.moveComplete()})
            
            self.sprite.runAction(actionMoveX)
            self.sprite.runAction(SKAction.sequence([actionMoveUpY, actionMoveDownY, actionMoveComplete]))
        }
        else {
            scene.resetLevel()
            if let nextTile = scene.getNextTile() {
                setPosition(nextTile.position.x, y: nextTile.position.y)
                self.scene.moveCamera(nextTile.position, speed: 0)
            }
        }
    }
    
    func moveComplete() {
        self.isMoving = false
    }
    
    func moveUp() {
//        let action = SKAction.scaleBy(2, duration: 1)
//        self.sprite.runAction(SKAction.repeatActionForever(action))
    }
}