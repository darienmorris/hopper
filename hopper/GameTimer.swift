//
//  Timer.swift
//  hopper
//
//  Created by Darien Morris on 2016-02-20.
//  Copyright © 2016 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit

class GameTimer: SKNode {
    var timerText: SKLabelNode = SKLabelNode(text: "0.0")
    var timeValue: Double = 0.0
    var timer: Timer!
    var isRunning: Bool = true
    
    override init() {
        super.init()
//        printFonts()
        
        timerText.fontName = "KenVector-Future"
        timerText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        addChild(timerText)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameTimer.addTime), userInfo: nil, repeats: true)
    }
    
    func addTime() {
        if isRunning {
            timeValue += 0.1
            setTime(timeValue)
        }
    }
    
    func setTime(_ time: Double) {
        timeValue = Double.roundToPlaces(num: timeValue, places: 1)
        timerText.text = timeValue.description
    }
    
    func pauseTime() {
        isRunning = false
    }
    
    func resetTime() {
        setTime(0.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    

}
