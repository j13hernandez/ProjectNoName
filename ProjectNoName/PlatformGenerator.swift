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
    let STARTING_DISTANCE_FROM_BOTTOM: CGFloat = 50
    let PLATFORM_DISTANCE_APART: CGFloat = 260
    
    var platforms = [Platform]()
    
    func calcNumOfPlatsPerScreen() -> Int
    {
        var ret = size.height
        ret -= STARTING_DISTANCE_FROM_BOTTOM
        ret /= PLATFORM_DISTANCE_APART
        ret = ceil(ret)
        ret += 1
        return Int(ret)
    }
    
    
    func generateStartScreenPlatforms()
    {
        let platform1 = Platform()
        platform1.position.x = size.width * 0.5
        platform1.position.y = STARTING_DISTANCE_FROM_BOTTOM
        platforms.append(platform1)
        addChild(platform1)
        
        let platform2 = Platform()
        platform2.position.x = size.width * 0.5
        platform2.position.y = STARTING_DISTANCE_FROM_BOTTOM + PLATFORM_DISTANCE_APART
        platform2.startRotation()
        platforms.append(platform2)
        addChild(platform2)
        
        for _ in 0 ..< calcNumOfPlatsPerScreen() - 2
        {
            generateNextPlatform(movingLong: false, movingLat: true)
        }
        
        
    }
    
    func generateNextPlatform(movingLong: Bool, movingLat: Bool)
    {
        let platform = Platform()
        
        let w: UInt32 = UInt32(size.width)
        let padding: UInt32 = 148 //74 pixels on each side
        let randRange: UInt32 = w-padding
        let rand = arc4random_uniform(randRange)
        
        platform.position.x = CGFloat(rand + padding/2)
        platform.position.y = (platforms.last?.position.y)! + PLATFORM_DISTANCE_APART
        
        platform.startRotation()
        
        platforms.append(platform)
        addChild(platform)
                
        if movingLong
        {
            platform.startMovingLong()
        }
        
        if movingLat
        {
            var bool = true
            if arc4random_uniform(2) == 0
            {
                bool = false
            }

            platform.startMovingLat(toRight: bool)
        }
    }
    
    func removeBottomPlatform()
    {
        platforms.first?.removeFromParent()
        platforms.removeFirst()
    }
    
}

