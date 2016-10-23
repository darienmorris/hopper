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
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            do {
                let sceneData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
                let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKNode
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
    static func roundToPlaces(num:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (num * divisor).rounded() / divisor
    }
}
