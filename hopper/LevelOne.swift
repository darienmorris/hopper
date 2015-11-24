//
//  GameScene.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright (c) 2015 Darien Morris. All rights reserved.
//

import SpriteKit


class GameScene: LevelScene {
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        var startX: CGFloat = CGRectGetMidX(self.frame)
        var startY: CGFloat = CGRectGetMidY(self.frame)
        
        if let tileOne = childNodeWithName("tile-1") {
            startX = tileOne.position.x
            startY = tileOne.position.y
        }
        
        self.player = Player(scene: self)
        self.player.addToScene(self, x: startX, y: startY)
        
    }
    

    
}
