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
    var currentPlatform: SKNode?
    var border: SKPhysicsBody!
    var joint = SKPhysicsJointFixed()
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.lightGray
        
        //Set Contact Delegate
        physicsWorld.contactDelegate = self
        
        addBorder()
        addStartingPlatform()
        addPlatformGenerator()
        addScoreLabel()
        
        //gen 2 rando plats
        for _ in 0..<2
        {
            platformGenerator.generateNextPlatform()
        }
        
        addBall()
    }
    
    func addBorder()
    {
        border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.collisionBitMask = UInt32(CollisionCategoryBitMask.Border)
        border.friction = 0
        self.physicsBody = border
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
    
    func addScoreLabel()
    {
        let scoreLabel = ScoreLabel(num: -1) //-1 to account for main platform
        scoreLabel.position = CGPoint(x: 20.0, y: view!.frame.size.height - 35)
        scoreLabel.name = "scoreLabel"
        addChild(scoreLabel)
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
        
        let dx: CGFloat = ball.position.x - (currentPlatform?.position.x)!
        let dy: CGFloat = ball.position.y - (currentPlatform?.position.y)!
        let dir = CGVector(dx: dx/10, dy: dy/10)
        
        ball.physicsBody?.applyImpulse(dir)
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
        
        if nodeA.categoryBitMask == UInt32(CollisionCategoryBitMask.Platform) &&
           nodeB.categoryBitMask == UInt32(CollisionCategoryBitMask.Ball)
        {
            if currentPlatform != nodeA {
                self.joinPhysicsBodies(bodyA: nodeA, bodyB: nodeB, point:contact.contactPoint)
                currentPlatform = nodeA.node
                let scoreLabel = childNode(withName: "scoreLabel") as! ScoreLabel
                scoreLabel.increment()
            }
        }
    }
}
