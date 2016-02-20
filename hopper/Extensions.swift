//
//  Extensions.swift
//  hopper
//
//  Created by Darien Morris on 2015-11-06.
//  Copyright © 2015 Darien Morris. All rights reserved.
//

import Foundation
import SpriteKit


extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            do {
                let sceneData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKNode
                archiver.finishDecoding()
                return scene
            }
            catch {
                return nil
            }
            
        } else {
            return nil
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}