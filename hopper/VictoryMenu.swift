//
//  VictoryMenu.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-29.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class VictoryMenu: SKNode {
    
    var titleLabel: SKLabelNode
    var closeButton: SKSpriteNode
    var container: SKSpriteNode
    var onReset: (() -> Void)?
    
    override init() {
        
        titleLabel = SKLabelNode(text: "Victory!")
//        closeButton = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        closeButton = SKSpriteNode(imageNamed: "button-retry")
        closeButton.name = "button-retry"
        container = SKSpriteNode(color: SKColor.darkGrayColor(), size: CGSize(width: 100, height: 100))
        
        super.init()

        zPosition = 100
        userInteractionEnabled = true
        
    }
    
    func setup(scene: SKScene, onReset: () -> Void) {
        self.onReset = onReset
        let frame: CGRect = scene.camera!.frame
        container.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        container.size = CGSize(width: scene.size.width / 2, height: scene.size.height / 2)
        
        titleLabel.position = CGPoint(x: 0, y: container.size.height / 2 - 50)
        container.addChild(titleLabel)
        
        closeButton.position = CGPoint(x:0, y: -(container.size.height / 2) + closeButton.size.height)
        container.addChild(closeButton)
        addChild(container)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // determine if they are touching the button
        
        for touch in touches {
            let nodes = self.nodesAtPoint(touch.locationInNode(self))
            for node in nodes
            {
                if node.name == "button-retry"
                {
                    // retry the level!
                    self.onReset!()
                    break
                }
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}