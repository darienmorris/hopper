//
//  GameScene.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-05.
//  Copyright (c) 2015 Darien Morris. All rights reserved.
//

import SpriteKit


class GameScene: LevelScene {
    override func didMove(to view: SKView) {
        starTimes = [0, 6, 2]
        levelName = "LevelDungeonOne"
        super.didMove(to: view)
    }
    

    
}
