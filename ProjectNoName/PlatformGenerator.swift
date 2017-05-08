//
//  PlatformGenerator.swift
//  ProjectNoName
//
//  Created by Cory Lennox on 5/5/17.
//  Copyright © 2017 Palm Studios. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformGenerator: SKSpriteNode
{
    var platforms = [Platform]()
    
    func generateNextPlatform()
    {
        let platform = Platform()
        
        let w: UInt32 = UInt32(size.width)
        let padding: UInt32 = 120 //60 pixels on each side
        let randRange: UInt32 = w-padding
        let rand = arc4random_uniform(randRange)
        
        platform.position.x = CGFloat(rand + padding/2)
        platform.position.y = CGFloat(platforms.count * 300 + 300)
        
        platforms.append(platform)
        addChild(platform)
    }
}

