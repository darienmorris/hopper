//
//  Level.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class LevelScene: SKScene {
    
    var player: Player!
    var tileNumber = 1
    var enemies: [Enemy] = []
    

    
    override func didMoveToView(view: SKView) {
        initGestures(view)
        initCamera()
        initEnemies()
        
        
    }
    
   
    func initCamera() {
        print("trying camera")
        if let camera:SKCameraNode = self.childNodeWithName("Camera") as? SKCameraNode {
            print("Camera!")
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
            self.enemies.append(Spinner(scene: self, node: node))
        }
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        player.moveUp()
    }
    
    func tap(sender:UISwipeGestureRecognizer) {
        player.moveForward()
    }
    
    func moveCamera(position: CGPoint, speed: Double) {
        if let camera = self.camera {
            camera.runAction(SKAction.moveToX(position.x, duration:speed))
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
    
    func getNextTile() -> SKNode? {
        tileNumber++
        if let tile = childNodeWithName("tile-\(tileNumber)") {
            return tile
        }
        
        return nil
    }
    
    func resetLevel() {
        tileNumber = 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }

}
