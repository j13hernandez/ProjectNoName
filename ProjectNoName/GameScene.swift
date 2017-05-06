//
//  GameScene.swift
//  ProjectNoName
//
//  Created by Julio "Jay Palm" Hernandez on 12/15/16.
//  Copyright © 2016 Palm Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    //member variables
    var platformGenerator: PlatformGenerator!
    var ball: Ball!
    var joint = SKPhysicsJointFixed()
    var impulseVector = CGVector()
    //var endLvlY = 0
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.lightGray
        
        // Load the level
        //let lvlPlist = Bundle.main.path(forResource: "Level01", ofType: "plist")
        //let lvlData = NSDictionary(contentsOfFile: lvlPlist!)!
        
        // Height at which the player ends the level
        //endLvlY = (lvlData["EndY"]! as AnyObject).integerValue!
        
        //Set Contact Delegate
        physicsWorld.contactDelegate = self
        
        addStartingPlatform()
        
        addPlatformGenerator()
        
        //gen 2 rando plats
        for _ in 0..<2
        {
            platformGenerator.generateNextPlatform()
        }
        
        addBall()
    }
    
    func addStartingPlatform()
    {
        let platformMain = Platform()
        platformMain.position = CGPoint(x: size.width * 0.5, y: size.height * 0.17)
        addChild(platformMain)
    }
    
    func addPlatformGenerator()
    {
        platformGenerator = PlatformGenerator(color: UIColor.clear, size: view!.frame.size)
        addChild(platformGenerator)
    }
    
    func addBall()
    {
        ball = Ball()
        ball.position = CGPoint(x: size.width / 2, y: size.height * 0.3)
        addChild(ball)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        scene?.physicsWorld.remove(joint)

        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.collisionBitMask = UInt32(CollisionCategoryBitMask.Border)
        border.friction = 0
        self.physicsBody = border

        var r = CGFloat()
        r = 5.0
        
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: r * cos(((ball.zRotation / 0.0174532925) + 90) * 0.0174532925), dy: r * sin(((ball.zRotation / 0.0174532925) + 90) * 0.0174532925)))
    }
    
    //function to attach nodes on contact
    func joinPhysicsBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody, point:CGPoint)
    {
        joint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: point)
        self.physicsWorld.add(joint)
    }
    
    //Attaches ball to platfrom on contact
    func didBegin(_ contact: SKPhysicsContact)
    {
        let nodeA = contact.bodyA
        let nodeB = contact.bodyB
        
        impulseVector = CGVector(dx: contact.contactPoint.x, dy: contact.contactPoint.y)
        
        if nodeA.categoryBitMask == UInt32(CollisionCategoryBitMask.Person) &&
           nodeB.categoryBitMask == UInt32(CollisionCategoryBitMask.Platform)
        {
            self.joinPhysicsBodies(bodyA: nodeA, bodyB: nodeB, point:contact.contactPoint)
        }
        
        if nodeA.categoryBitMask == UInt32(CollisionCategoryBitMask.Platform) &&
           nodeB.categoryBitMask == UInt32(CollisionCategoryBitMask.Person)
        {
            self.joinPhysicsBodies(bodyA: nodeA, bodyB: nodeB, point:contact.contactPoint)
        }
    }
}
