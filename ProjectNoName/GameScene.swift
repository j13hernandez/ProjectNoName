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
        physicsWorld.gravity = CGVector(dx: CGFloat(0), dy: CGFloat(0))
        
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
        border.node?.name = "border"
        border.categoryBitMask = CollisionCategoryBitMask.Border
        border.contactTestBitMask = CollisionCategoryBitMask.Ball
        border.collisionBitMask = 0
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
        ball.position = CGPoint(x: size.width / 2, y: size.height * 0.23)
        addChild(ball)
        let dir = CGVector(dx: 0, dy: -1)
        ball.physicsBody?.applyImpulse(dir)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        scene?.physicsWorld.remove(joint)
        
        // Calculate vector components x and y
        var dx: CGFloat = ball.position.x - (currentPlatform?.position.x)!
        var dy: CGFloat = ball.position.y - (currentPlatform?.position.y)!
        
        // Normalize the components
        let magnitude = sqrt(dx*dx+dy*dy)
        dx /= magnitude
        dy /= magnitude
        
        let strength: CGFloat = 2.5
        
        let dir = CGVector(dx: dx * strength, dy: dy * strength)
        
        ball.physicsBody?.applyImpulse(dir)
    }
    
    //function to attach nodes on contact
    func joinPhysicsBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody, point:CGPoint)
    {
        joint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: point)
        self.physicsWorld.add(joint)
    }
    
    //contact between two PhysicsBodys occurred
    func didBegin(_ contact: SKPhysicsContact)
    {
        let nodeA = contact.bodyA.categoryBitMask
        //nodeB is always ball
        
        
        if nodeA == CollisionCategoryBitMask.Border
        {
            restart()
        }
        
        //one of the nodes is a platform
        if nodeA == CollisionCategoryBitMask.Platform
        {
            if currentPlatform != contact.bodyA
            {
                self.joinPhysicsBodies(bodyA: contact.bodyA, bodyB: contact.bodyB, point:contact.contactPoint)
                currentPlatform = contact.bodyA.node
                let scoreLabel = childNode(withName: "scoreLabel") as! ScoreLabel
                scoreLabel.increment()
            }
        }
    }
    
    func restart() {
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene)
    }
}
