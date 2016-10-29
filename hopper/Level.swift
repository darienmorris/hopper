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
    case wingMan = 3
    case someOtherThing = 4
}

class LevelScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var tileNumber = 1
    var enemies: [Enemy] = []
    var levelName = ""
    var cameraOffset: CGSize = CGSize(width: 100, height: 0)
    var gameTimer: GameTimer = GameTimer()
    var cameraBG: SKCameraNode!
    var cameraParallaxRatioBG: CGFloat = 0.8
    var starTimes: [Double] = [0, 5, 10]

    
    override func didMove(to view: SKView) {
        initGestures(view)
        
        initEnemies()
        
        initPhysics()
        initPlayer()
        
        initCamera()
        initBG()
        initTimer()
    }
    
    func initTimer() {
        gameTimer.position = CGPoint(x: player.sprite.position.x - cameraOffset.width * 1.75, y: camera!.position.y + UIScreen.main.bounds.size.height / 3)
        

        addChild(gameTimer)
    }
    
   
    func initCamera() {
        if let camera:SKCameraNode = self.childNode(withName: "camera") as? SKCameraNode {
            camera.position = CGPoint(x: player.sprite.position.x + cameraOffset.width, y:player.sprite.position.y + UIScreen.main.bounds.size.height * 0.15)
            self.camera = camera
            
        }
        
        if let camera:SKCameraNode = self.childNode(withName: "camera-bg") as? SKCameraNode {
            camera.position = CGPoint(x: player.sprite.position.x * cameraParallaxRatioBG + cameraOffset.width, y:player.sprite.position.y)
            self.cameraBG = camera
            
        }
    }
    
    func initGestures(_ view: SKView) {
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(LevelScene.swipedUp(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LevelScene.tap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func initEnemies() {
        self.enumerateChildNodes(withName: "spinner-*") {
            node, stop in
            let enemySprite: SKSpriteNode = node as! SKSpriteNode
            self.enemies.append(Spinner(scene: self, sprite: enemySprite))
        }
        
        self.enumerateChildNodes(withName: "flyer-*") {
            node, stop in
            let enemySprite: SKSpriteNode = node as! SKSpriteNode
            self.enemies.append(Flyer(scene: self, sprite: enemySprite))
        }
    }
    
    func initBG() {
        self.cameraBG.enumerateChildNodes(withName: "cloud") {
            node, stop in
            print("found a cloud")
            let cloud: SKSpriteNode = node as! SKSpriteNode
            let delay: Float = Float(2 + drand48())
            let duration: Double = (Double)(Float(cloud.position.x) * delay)
            cloud.run(SKAction.repeatForever(SKAction.moveTo(x: -1000, duration:duration)))
        }
    }
    
    func initPhysics() {
        physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func initPlayer() {
        var startX: CGFloat = self.frame.midX
        var startY: CGFloat = self.frame.midY

        if let tileOne = childNode(withName: "tile-1") {
            startX = tileOne.position.x
            startY = tileOne.position.y
        }
        
        self.player = Player(scene: self)
        self.player.addToScene(self, x: startX, y: startY)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Called automatically when two objects begin contact
        var enemyBody: SKPhysicsBody
        var playerBody: SKPhysicsBody
        
        
        
        if contact.bodyA.categoryBitMask == BodyType.player.rawValue {
            playerBody = contact.bodyA
            enemyBody = contact.bodyB
        }
        else if contact.bodyB.categoryBitMask == BodyType.player.rawValue {
            playerBody = contact.bodyB
            enemyBody = contact.bodyA
        }
        else {
            return
        }

        // This won't be scalable.. maybe implement a contact method for each enemy, and pass in the two sprites and return who wins the contact
        if player.isAlive {
            if enemyBody.categoryBitMask == BodyType.spinner.rawValue {
                runDeathSequence()
            }
            else if enemyBody.categoryBitMask == BodyType.wingMan.rawValue {
                if let enemyNode = enemyBody.node as? SKSpriteNode, let playerNode = playerBody.node as? SKSpriteNode {

                    if playerNode.position.y - playerNode.size.height < enemyNode.position.y - enemyNode.size.height / 2 {
                        runDeathSequence()
                    }
                    else {
                        if let wingMan = findEnemyByName(name: enemyNode.name!) as! Flyer? {
                            player.bounce()
                            wingMan.die()
                        }
                    }
                }
            }
            
        }
        
    }
    
    func pauseEnemies() {
        for enemy in enemies {
            enemy.pause()
        }
    }
    
    func findEnemyByName(name: String) -> Enemy? {
        for enemy in enemies {
            if enemy.sprite.name == name {
                return enemy
            }
        }
        
        return nil
    }
    
    func runDeathSequence() {
        pauseEnemies()
        player.die()
        camera!.removeAllActions()
        cameraBG.removeAllActions()
        gameTimer.removeAllActions()
        gameTimer.pauseTime()
        run(SKAction.sequence([SKAction.wait(forDuration: 0.75), SKAction.run({
            self.resetLevel()
        })]))
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    
    func swipedUp(_ sender:UISwipeGestureRecognizer){
        player.moveUp()
    }
    
    func tap(_ sender:UISwipeGestureRecognizer) {
        player.moveForward()
    }
    
    func moveCamera(_ position: CGPoint, speed: Double) {
        if let camera = self.camera {
            camera.run(SKAction.moveTo(x: position.x + cameraOffset.width, duration:speed))
            cameraBG.run(SKAction.moveTo(x: position.x * cameraParallaxRatioBG + cameraOffset.width, duration: speed))
            gameTimer.run(SKAction.moveTo(x: position.x - cameraOffset.width * 1.75 , duration:speed))
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
  
    }
    
    func printAllNodes() {
        self.enumerateChildNodes(withName: "//*") {
            node, stop in
            print(node)
        }
    }
    
    func setNextTile() {
        tileNumber += 1
    }
    
    func getNextTile() -> SKNode? {
        if let tile = childNode(withName: "tile-\(tileNumber + 1)") {
            return tile
        }
        
        return nil
    }
    
    func getFirstTile() -> SKNode? {
        if let tile = childNode(withName: "tile-1") {
            return tile
        }
        
        return nil
    }
    
    func resetLevel() {
        if let scene = GameScene(fileNamed:levelName) {
            scene.scaleMode = .resizeFill
            let skView = self.view! as SKView
            scene.size = skView.bounds.size
            self.view?.presentScene(scene)
        }
    }
    
    func checkForVictory() {
        if getNextTile() == nil {
            gameTimer.pauseTime()
            openVictoryMenu()
        }
    }
    
    func openVictoryMenu() {
        let victoryMenu = VictoryMenu()
        victoryMenu.setup(self, gameTime: gameTimer.timeValue, starTimes: starTimes, onReset: {
            self.resetLevel()
        })
        addChild(victoryMenu)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

}
