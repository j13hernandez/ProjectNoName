//
//  Ball.swift
//  ProjectNoName
//
//  Created by Cory Lennox on 5/6/17.
//  Copyright © 2017 Palm Studios. All rights reserved.
//


import Foundation
import SpriteKit

class Ball: SKSpriteNode
{
    init()
    {
        let texture = SKTexture(imageNamed: "whiteCircle")
        let size = CGSize(width: 10, height: 10)
        super.init(texture: texture, color: UIColor.clear, size: size)
        
        loadPhysicsBodyWithSize(size: size)
    }
    
    func loadPhysicsBodyWithSize(size: CGSize)
    {
        physicsBody = SKPhysicsBody(circleOfRadius: 5)
        physicsBody?.node?.name = "ball"
        physicsBody?.isDynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategoryBitMask.Ball
        physicsBody?.contactTestBitMask = CollisionCategoryBitMask.Platform
        physicsBody?.collisionBitMask = 0
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
