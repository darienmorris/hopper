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
    var background: SKSpriteNode
    
    override init() {
        titleLabel = SKLabelNode(text: "Victory!")
        closeButton = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        background = SKSpriteNode(color: SKColor.darkGrayColor(), size: CGSize(width: 100, height: 100))
        
        super.init()
        
        
    }
    
    func render(scene: SKScene) {
        let frame: CGRect = scene.camera!.frame
        background.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        background.size = CGSize(width: scene.size.width / 2, height: scene.size.height / 2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        addChild(titleLabel)
        addChild(closeButton)
        addChild(background)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}