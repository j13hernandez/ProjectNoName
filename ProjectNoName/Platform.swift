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
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: 40, height: 40))
        
        loadPhysicsBody()
        
        //add rotation
        run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: 2)))
    }   
    
    func loadPhysicsBody()
    {
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = UInt32(CollisionCategoryBitMask.Platform)
        physicsBody?.contactTestBitMask = UInt32(CollisionCategoryBitMask.Person)
        physicsBody?.collisionBitMask = UInt32(CollisionCategoryBitMask.Person)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
