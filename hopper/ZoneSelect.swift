//
//  Level.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class ZoneSelect: SKScene, SKPhysicsContactDelegate {
    
    var zoneDungeonButton: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        zoneDungeonButton = childNode(withName: "zone-dungeon") as? SKSpriteNode
        print("ZONE SELECT")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        if zoneDungeonButton.contains(touch.location(in: self)) {
            goToLevelSelect(zone: "Dungeon")
        }
    }
    
    func goToLevelSelect(zone: String) {
        if let scene = GameScene(fileNamed:zone+"LevelSelect") {
            scene.scaleMode = .resizeFill
            let skView = self.view! as SKView
            scene.size = skView.bounds.size
            self.view?.presentScene(scene)
        }
    }
    
}
