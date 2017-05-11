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
    var isMovingRight: Bool?
    var moveRight: SKAction!
    var moveLeft: SKAction!
    
    init()
    {
        let texture = SKTexture(imageNamed: "platform1")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        let rad: CGFloat = texture.size().width/2
        loadPhysicsBodyWithRad(rad)
        loadLateralMoveActions()
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
        if arc4random_uniform(2) == 0
        {
            run(SKAction.repeatForever(SKAction.rotate(byAngle: PLATFORM_ROTATION_SPEED, duration: 1)))
        }
        else
        {
            run(SKAction.repeatForever(SKAction.rotate(byAngle: -PLATFORM_ROTATION_SPEED, duration: 1)))
        }
    }
    
    func startMovingLong() {
        let moveDown = SKAction.moveBy(x: 0, y: -PLATFORM_DESCENT_SPEED, duration: 1)
        run(SKAction.repeatForever(moveDown))
    }
    
    func startMovingLat(toRight: Bool)
    {
        if toRight
        {
            removeAction(forKey: "moveLeft")
            run(SKAction.repeatForever(moveRight), withKey: "moveRight")
            isMovingRight = true
        }
        else
        {
            removeAction(forKey: "moveRight")
            run(SKAction.repeatForever(moveLeft), withKey: "moveLeft")
            isMovingRight = false
        }
    }
    
    func loadLateralMoveActions()
    {
        moveRight = SKAction.moveBy(x: PLATFORM_LATERAL_SPEED, y: 0, duration: 1)
        
        moveLeft = SKAction.moveBy(x: -PLATFORM_LATERAL_SPEED, y:0, duration: 1)
    }
    
    func stopActions() {
        removeAllActions()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
