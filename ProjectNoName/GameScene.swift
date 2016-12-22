//
//  GameScene.swift
//  ProjectNoName
//
//  Created by Julio "Jay Palm" Hernandez on 12/15/16.
//  Copyright © 2016 Palm Studios. All rights reserved.
//

import SpriteKit
import GameplayKit

//Feel free to change varible names to more conventional ones - Jay Palm
class GameScene: SKScene, SKPhysicsContactDelegate {

    //Global variables
    var ball = SKNode()
    var foregroundNode = SKNode()

    //Not sure what this is tbh lol
    required init?(coder aDecoder: NSCoder)
    {
        
        super.init(coder: aDecoder)
    }
    
    //Esentially our main() function
    override init(size: CGSize)
    {
        
        super.init(size: size)
        //Gravity for our universe

        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        //Set Contact Delegate
        physicsWorld.contactDelegate = self    

        backgroundColor = SKColor.black
        //Add Moving Layer
        foregroundNode = SKNode()
        addChild(foregroundNode)
        //Add Platfrom
        let platform = createStartingPlatform(ofType: .Normal)
        foregroundNode.addChild(platform)
        //Add Player
        ball = createPlayer()
        foregroundNode.addChild(ball)
    }
    

    //When User touches screen for the first time, pushes player up
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

        if (ball.physicsBody!.isDynamic){
            return
        }
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: -0.2, dy: 1.0))
        
    }
    
    //Player/ball create function
    func createPlayer() -> SKNode
    {
        
        //creates ball node
        let ballNode = SKNode()
        //physics body so that gravity affects it
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        ballNode.physicsBody?.isDynamic = false
        ballNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        //physics to add collision detection
        ballNode.physicsBody?.usesPreciseCollisionDetection = true
        ballNode.physicsBody?.categoryBitMask = UInt32(CollisionCategoryBitMask.Person)
        ballNode.physicsBody?.collisionBitMask = UInt32(CollisionCategoryBitMask.Platform)
        ballNode.physicsBody?.contactTestBitMask = UInt32(CollisionCategoryBitMask.Platform)
        //Adds image to the ball
        let sprite = SKSpriteNode(imageNamed: "whiteCircle")
        sprite.size = CGSize(width: 10, height: 10)
        ballNode.addChild(sprite)
        
        
        return ballNode
    }
    
    func createStartingPlatform(ofType type: PlatfromType) -> PlatfromNode {
        
        let node = PlatfromNode()
        node.position = CGPoint(x: size.width * 0.5, y: size.height * 0.17)
        node.name = "STARING_PLATFORM"
        
        var sprite = SKSpriteNode()
        sprite = SKSpriteNode(imageNamed: "test")
        sprite.size = CGSize(width: 40, height: 40)
        //Adds image to platform
        node.addChild(sprite)
        //Physics for platform
        node.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = UInt32(CollisionCategoryBitMask.Platform)
        node.physicsBody?.contactTestBitMask = UInt32(CollisionCategoryBitMask.Person)
        node.physicsBody?.collisionBitMask = UInt32(CollisionCategoryBitMask.Person)
        
        
        //Makes platform spin
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: 2)))
        
        return node
    }
    
    
    //function to attach nodes on contact
    func joinPhysicsBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody, point:CGPoint) {
        let joint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: point)
        self.physicsWorld.add(joint)
    }
    
    
    //Attaches ball to platfrom on contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA
        let nodeB = contact.bodyB
        
        if nodeA.categoryBitMask == UInt32(CollisionCategoryBitMask.Person) && nodeB.categoryBitMask == UInt32(CollisionCategoryBitMask.Platform){
            self.joinPhysicsBodies(bodyA: nodeA, bodyB: nodeB, point:contact.contactPoint)
        }else{
            self.joinPhysicsBodies(bodyA: nodeA, bodyB: nodeB, point:contact.contactPoint)
        }
    }

}
