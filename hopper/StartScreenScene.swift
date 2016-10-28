//
//  Level.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class StartScreenScene: SKScene, SKPhysicsContactDelegate {
    
    var startButton: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        startButton = childNode(withName: "button-start") as? SKSpriteNode
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        if startButton.contains(touch.location(in: self)) {
            goToZoneSelect()
        }
    }
    
    func goToZoneSelect() {
        if let scene = GameScene(fileNamed:"ZoneSelect") {
            scene.scaleMode = .resizeFill
            let skView = self.view! as SKView
            scene.size = skView.bounds.size
            self.view?.presentScene(scene)
        }
    }
    
}
