//
//  Level.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class DungeonLevelSelect: SKScene, SKPhysicsContactDelegate {
    
    var levelOne: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {        
        levelOne = childNode(withName: "level-1") as? SKSpriteNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        if levelOne.contains(touch.location(in: self)) {
            goToLevel(id: "One")
        }
    }
    
    func goToLevel(id: String) {
        if let scene = GameScene(fileNamed:"LevelDungeon"+id) {
            scene.scaleMode = .resizeFill
            let skView = self.view! as SKView
            scene.size = skView.bounds.size
            self.view?.presentScene(scene)
        }
    }
    
}
