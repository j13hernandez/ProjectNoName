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
    let PLATFORM_DESCENT_SPEED: CGFloat = 100
    
    init()
    {
        let texture = SKTexture(imageNamed: "platform1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        let rad: CGFloat = texture.size().width/2
        loadPhysicsBodyWithRad(rad)
        self.setScale(CGFloat(0.183))
    }
    
    func loadPhysicsBodyWithRad(_ cirRad: CGFloat)
    {
        physicsBody = SKPhysicsBody(circleOfRadius: cirRad)
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = CollisionCategoryBitMask.Platform
        physicsBody?.contactTestBitMask = CollisionCategoryBitMask.Ball
        physicsBody?.collisionBitMask = 0
    }
    
    func startRotation()
    {
        run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 0.75, duration: 1)))
    }
    
    func startDescending() {
        let moveDown = SKAction.moveBy(x: 0, y: -PLATFORM_DESCENT_SPEED, duration: 1)
        run(SKAction.repeatForever(moveDown))
    }
    
    func stopActions() {
        removeAllActions()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
