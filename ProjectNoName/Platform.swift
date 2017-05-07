//
//  Platform.swift
//  ProjectNoName
//
//  Created by Cory Lennox on 5/5/17.
//  Copyright © 2017 Palm Studios. All rights reserved.
//

import Foundation
import SpriteKit

class Platform: SKSpriteNode {
    init()
    {
        let texture = SKTexture(imageNamed: "platform1")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 55, height: 55))
        
        loadPhysicsBody()
        
        //add rotation
        run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 0.75, duration: 1)))
    }   
    
    func loadPhysicsBody()
    {
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody?.node?.name = "platform"
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategoryBitMask.Platform
        physicsBody?.contactTestBitMask = CollisionCategoryBitMask.Ball
        physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
