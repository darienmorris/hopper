//
//  Level.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit


enum BodyType:UInt32 {
    case player = 1
    case spinner = 2
    case someOtherThing = 4
}

class LevelScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var tileNumber = 1
    var enemies: [Enemy] = []
    var levelName = ""
    var cameraOffset: CGSize = CGSize(width: 100, height: 0)
    
    override func didMoveToView(view: SKView) {
        initGestures(view)
        
        initEnemies()
        initPhysics()
        initPlayer()
        
        initCamera()
        
        
        
        
    }
    
   
    func initCamera() {
        if let camera:SKCameraNode = self.childNodeWithName("Camera") as? SKCameraNode {
            camera.position = CGPoint(x: player.sprite.position.x + cameraOffset.width, y:player.sprite.position.y)
            self.camera = camera
            
        }
    }
    
    func initGestures(view: SKView) {
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        view.addGestureRecognizer(tap)
    }
    
    func initEnemies() {
        self.enumerateChildNodesWithName("spinner-*") {
            node, stop in
            let enemySprite: SKSpriteNode = node as! SKSpriteNode
            self.enemies.append(Spinner(scene: self, sprite: enemySprite))
        }
    }
    
    func initPhysics() {
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func initPlayer() {
        var startX: CGFloat = CGRectGetMidX(self.frame)
        var startY: CGFloat = CGRectGetMidY(self.frame)

        if let tileOne = childNodeWithName("tile-1") {
            startX = tileOne.position.x
            startY = tileOne.position.y
        }
        
        self.player = Player(scene: self)
        self.player.addToScene(self, x: startX, y: startY)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Called automatically when two objects begin contact
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case BodyType.player.rawValue | BodyType.spinner.rawValue:
            //either the contact mask was the player or spinner
            if player.isAlive {
                runDeathSequence()
                pauseEnemies()
            }
        default:
            return
        }
        
    }
    
    func pauseEnemies() {
        for enemy in enemies {
            enemy.pause()
        }
    }
    
    func runDeathSequence() {
        player.die()
        camera!.removeAllActions()
        runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.runBlock({
            self.resetLevel()
        })]))
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        player.moveUp()
    }
    
    func tap(sender:UISwipeGestureRecognizer) {
        player.moveForward()
    }
    
    func moveCamera(position: CGPoint, speed: Double) {
        if let camera = self.camera {
            camera.runAction(SKAction.moveToX(position.x + cameraOffset.width, duration:speed))
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
    
    func printAllNodes() {
        self.enumerateChildNodesWithName("//*") {
            node, stop in
            print(node)
        }
    }
    
    func setNextTile() {
        tileNumber++
    }
    
    func getNextTile() -> SKNode? {
        if let tile = childNodeWithName("tile-\(tileNumber + 1)") {
            return tile
        }
        
        return nil
    }
    
    func getFirstTile() -> SKNode? {
        if let tile = childNodeWithName("tile-1") {
            return tile
        }
        
        return nil
    }
    
    func resetLevel() {
        if let scene = GameScene(fileNamed:levelName) {
            scene.scaleMode = .AspectFill
            let skView = self.view! as SKView
            scene.size = skView.bounds.size
            self.view?.presentScene(scene)
        }
    }
    
    func checkForVictory() {
        if getNextTile() == nil {
            openVictoryMenu()
        }
    }
    
    func openVictoryMenu() {
        let victoryMenu = VictoryMenu()
        victoryMenu.setup(self, onReset: {
            self.resetLevel()
        })
        addChild(victoryMenu)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }

}
