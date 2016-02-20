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
    var menuButton: SKSpriteNode
    var playButton: SKSpriteNode
    var container: SKSpriteNode
    var overlay: SKSpriteNode
    var onReset: (() -> Void)?
    
    override init() {
        
        titleLabel = SKLabelNode(text: "Victory!")
        titleLabel.fontName = "KenVector-Future"
        
        closeButton = SKSpriteNode(imageNamed: "button-retry")
        closeButton.name = "button-retry"
        
        menuButton = SKSpriteNode(imageNamed: "button-menu")
        menuButton.name = "button-menu"
        
        playButton = SKSpriteNode(imageNamed: "button-play")
        playButton.name = "button-play"
        
        container = SKSpriteNode(imageNamed: "victory-menu")
        overlay = SKSpriteNode(color: SKColor.darkGrayColor(), size: CGSize(width: 0, height: 0))
        overlay.alpha = 0
        super.init()

        zPosition = 100
        userInteractionEnabled = true
        
    }
    
    func setup(scene: SKScene, onReset: () -> Void) {
        self.onReset = onReset
        let frame: CGRect = scene.camera!.frame
        
        overlay.position = CGPoint(x: frame.origin.x, y: frame.origin.y)
        overlay.size = CGSize(width: scene.size.width, height: scene.size.height)
        addChild(overlay)
        
        container.position = CGPoint(x: CGRectGetMidX(frame), y: frame.origin.y - container.size.height)
        container.size = CGSize(width: scene.size.width / 2, height: scene.size.width / 2 * 0.66)
        
        titleLabel.position = CGPoint(x: 0, y: container.size.height / 2 - 50)
        titleLabel.zPosition = 1
        container.addChild(titleLabel)
        
        closeButton.position = CGPoint(x:-closeButton.size.width - 20, y: -(container.size.height / 2) + closeButton.size.height)
        closeButton.zPosition = 1
        container.addChild(closeButton)
        
        menuButton.position = CGPoint(x:0, y: -(container.size.height / 2) + menuButton.size.height)
        menuButton.zPosition = 1
        container.addChild(menuButton)
        
        playButton.position = CGPoint(x:playButton.size.width + 20, y: -(container.size.height / 2) + playButton.size.height)
        playButton.zPosition = 1
        container.addChild(playButton)
        addChild(container)
        
        
        fadeOverlayIn()
        moveContainerIn(frame)
        
        
        
    }
    
    func fadeOverlayIn() {
        let overlayFadeIn = SKAction.fadeAlphaTo(0.7, duration: 0.20)
        overlayFadeIn.timingMode = SKActionTimingMode.EaseIn
        overlay.runAction(overlayFadeIn)
    }
    
    func moveContainerIn(frame: CGRect) {
        let containerAction = SKAction.moveToY(CGRectGetMidY(frame), duration: 0.4)
        containerAction.timingMode = SKActionTimingMode.EaseInEaseOut
        container.runAction(containerAction)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // determine if they are touching the button
        
        for touch in touches {
            let nodes = self.nodesAtPoint(touch.locationInNode(self))
            for node in nodes
            {
                if node.name == "button-retry" || node.name == "button-menu" || node.name == "button-play"
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