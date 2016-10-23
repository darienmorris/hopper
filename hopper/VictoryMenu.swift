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
    var retryButton: SKSpriteNode
    var menuButton: SKSpriteNode
    var playButton: SKSpriteNode
    var container: SKSpriteNode
    var overlay: SKSpriteNode
    
    var starOne: SKSpriteNode
    var starTwo: SKSpriteNode
    var starThree: SKSpriteNode
    var onReset: (() -> Void)?
    
    var yourTimeText: SKLabelNode
    var nextStarText: SKLabelNode
    
    var gameTime: Double = 0
    var starTimes: [Double] = []
    override init() {
        
        titleLabel = SKLabelNode(text: "Victory!")
        titleLabel.fontName = "KenVector-Future"
        
        retryButton = SKSpriteNode(imageNamed: "button-retry")
        retryButton.name = "button-retry"
        
        menuButton = SKSpriteNode(imageNamed: "button-menu")
        menuButton.name = "button-menu"
        
        playButton = SKSpriteNode(imageNamed: "button-play")
        playButton.name = "button-play"
        
        container = SKSpriteNode(imageNamed: "victory")
        overlay = SKSpriteNode(color: SKColor.darkGray, size: CGSize(width: 0, height: 0))
        overlay.alpha = 0
        
        
        starOne = SKSpriteNode(imageNamed: "star")
        starTwo = SKSpriteNode(imageNamed: "star")
        starThree = SKSpriteNode(imageNamed: "star")
        
        yourTimeText = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        nextStarText = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        
        super.init()

        zPosition = 100
        isUserInteractionEnabled = true
        
    }
    
    func setup(_ scene: SKScene, gameTime: Double, starTimes: [Double], onReset: @escaping () -> Void) {
        self.onReset = onReset
        self.gameTime = gameTime
        self.starTimes = starTimes
        
        let frame: CGRect = scene.camera!.frame
        
        overlay.position = CGPoint(x: frame.origin.x, y: frame.origin.y)
        overlay.size = CGSize(width: scene.size.width, height: scene.size.height)
        addChild(overlay)
        
        container.position = CGPoint(x: frame.midX, y: frame.origin.y - container.size.height)
        
        setupButtons()
        setupStars()
        setupText()

        addChild(container)
        
        fadeOverlayIn()
        moveContainerIn(frame)
    }
    
    func setupText() {
        yourTimeText.position = CGPoint(x: 0, y: -10)
        yourTimeText.zPosition = 1
        yourTimeText.text = "Finish time: \(gameTime.description)"
        yourTimeText.fontColor = UIColor(red: 0.75, green: 0.376, blue: 0, alpha: 1)
        yourTimeText.fontSize = 30
        
        nextStarText.position = CGPoint(x: 0, y: -50)
        nextStarText.zPosition = 1
        nextStarText.text = "You got all the stars!"
        nextStarText.fontColor = UIColor(red: 0.745, green: 0.5, blue: 0, alpha: 1)
        nextStarText.fontSize = 25
        
        if gameTime > starTimes[1] {
            nextStarText.text = "Next star: \(starTimes[1])"
        }
        else if gameTime > starTimes[2] {
            nextStarText.text = "Next star: \(starTimes[2])"
        }
        
        container.addChild(yourTimeText)
        container.addChild(nextStarText)
    }
    
    func setupButtons() {
        let buttonsY = -(container.size.height / 2) + retryButton.size.height / 4
        let buttonMarginX: CGFloat = 10
        
        retryButton.position = CGPoint(x:0, y: buttonsY)
        retryButton.zPosition = 1
        container.addChild(retryButton)
        
        menuButton.position = CGPoint(x:-retryButton.size.width - buttonMarginX, y: buttonsY)
        menuButton.zPosition = 1
        container.addChild(menuButton)
        
        playButton.position = CGPoint(x:playButton.size.width + buttonMarginX, y: buttonsY)
        playButton.zPosition = 1
        container.addChild(playButton)
    }
    
    func setupStars() {
        let starsY: CGFloat = container.size.height / 2 - starOne.size.height / 2
        let starMarginX: CGFloat = -5
        let starRotation: CGFloat = 3.14/9
        let smallStarSize = CGSize(width: starTwo.size.width * 0.9, height: starTwo.size.height * 0.9)
        
        
        starOne.position = CGPoint(x:-starTwo.size.width - starMarginX, y: starsY)
        starOne.zPosition = 1
        starOne.run(SKAction.colorize(with: UIColor.gray, colorBlendFactor: 1, duration: 0))
        starOne.size = smallStarSize
        starOne.run(SKAction.rotate(byAngle: starRotation, duration: 0))
        
        starTwo.position = CGPoint(x:0, y: starsY)
        starTwo.run(SKAction.colorize(with: UIColor.gray, colorBlendFactor: 1, duration: 0))
        starTwo.zPosition = 1
        
        starThree.position = CGPoint(x:starTwo.size.width + starMarginX, y: starsY)
        starThree.zPosition = 1
        starThree.run(SKAction.colorize(with: UIColor.gray, colorBlendFactor: 1, duration: 0))
        starThree.size = smallStarSize
        starThree.run(SKAction.rotate(byAngle: -starRotation, duration: 0))
        
        
        container.addChild(starOne)
        container.addChild(starTwo)
        container.addChild(starThree)
    }
    
    func fadeOverlayIn() {
        let overlayFadeIn = SKAction.fadeAlpha(to: 0.7, duration: 0.20)
        overlayFadeIn.timingMode = SKActionTimingMode.easeIn
        overlay.run(overlayFadeIn)
    }
    
    func moveContainerIn(_ frame: CGRect) {
        let containerAction = SKAction.moveTo(y: frame.midY, duration: 0.4)
        containerAction.timingMode = SKActionTimingMode.easeInEaseOut
        container.run(containerAction, completion: animateStars)
    }
    
    func animateStars() {
        let animationDelay = 0.5
        var actions: [SKAction] = []
        
        actions.append(SKAction.run({self.animateStar(self.starOne)}))
        
        if gameTime <= starTimes[1] {
            actions.append(SKAction.wait(forDuration: animationDelay))
            actions.append(SKAction.run({self.animateStar(self.starTwo)}))
        }
        
        if gameTime <= starTimes[2] {
            actions.append(SKAction.wait(forDuration: animationDelay))
            actions.append(SKAction.run({self.animateStar(self.starThree)}))
        }
        
        
        let sequence = SKAction.sequence(actions)
        
        run(sequence)
    }
    
    func animateStar(_ star: SKSpriteNode) {
        let sequence = SKAction.sequence([SKAction.scale(by: 1.2, duration: 0.25), SKAction.scale(by: 0.8333, duration: 0.25)])
        star.run(sequence)
        star.run(SKAction.colorize(with: UIColor.white, colorBlendFactor: 0, duration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // determine if they are touching the button
        
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
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
