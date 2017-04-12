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
    var touch = Bool()
    var joint = SKPhysicsJointFixed()
    var impulseVector = CGVector()
    var endLvlY = 0
    
    //Not sure what this is tbh lol
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
    }
    
    //Esentially our main() function
    override init(size: CGSize){
        
        // Load the level
        let lvlPlist = Bundle.main.path(forResource: "Level01", ofType: "plist")
        let lvlData = NSDictionary(contentsOfFile: lvlPlist!)!
        
        // Height at which the player ends the level
        endLvlY = (lvlData["EndY"]! as AnyObject).integerValue!
        
        super.init(size: size)
        //Gravity for our universe
        //physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        //Set Contact Delegate
        physicsWorld.contactDelegate = self
        backgroundColor = SKColor.black
        //Add Moving Layer
        foregroundNode = SKNode()
        addChild(foregroundNode)
        //Add Platfrom
        let platformMain = createStartingPlatform(ofType: .Normal)
        foregroundNode.addChild(platformMain)
        //Additional PLatforms
        let platform = lvlData["Platforms"] as! NSDictionary
        let platformPatterns = platform["Patterns"] as! NSDictionary
        let platformPositions = platform["Positions"] as! [NSDictionary]
        
        for platformPosition in platformPositions{
            let patternX = (platformPosition["x"] as AnyObject).floatValue
            let patternY = (platformPosition["y"] as AnyObject).floatValue
            let pattern = platformPosition["pattern"] as! NSString
            
            let platformPattern = platformPatterns[pattern] as! [NSDictionary]
            for platformPoint in platformPattern {
                let x = (platformPoint["x"] as AnyObject).floatValue
                let y = (platformPoint["y"] as AnyObject).floatValue
                let type = PlatformType(rawValue: (platformPoint["type"]! as AnyObject).integerValue)
                let positionX = CGFloat(x! + patternX!)
                let positionY = CGFloat(y! + patternY!)
                let platformNode = createPlatform(position: CGPoint(x: positionX, y: positionY), ofType: type!)
                foregroundNode.addChild(platformNode)
            }
        }
        //Add Player
        ball = createPlayer()
        foregroundNode.addChild(ball)
        
        
    }
    

    //When User touches screen, pushes player up
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.collisionBitMask = UInt32(CollisionCategoryBitMask.Border)
        border.friction = 0
        self.physicsBody = border

        var r = CGFloat()
        r = 5.0
        ball.physicsBody?.isDynamic = true
        //ball.physicsBody?.applyForce(impulseVector)
        //ball.physicsBody?.applyImpulse(impulseVector)
        
        
        ball.physicsBody?.applyImpulse(CGVector(dx: r * cos(((ball.zRotation / 0.0174532925) + 90) * 0.0174532925), dy: r * sin(((ball.zRotation / 0.0174532925) + 90) * 0.0174532925)))
        if touch == true{
            scene?.physicsWorld.remove(joint)
        }
    }
    
    //Player/ball create function
    func createPlayer() -> SKNode {
        
        //creates ball node
        let ballNode = SKNode()
        //physics body so that gravity affects it
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        ballNode.physicsBody?.isDynamic = true
        ballNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.3)
        //physics to add collision detection
        ballNode.physicsBody?.usesPreciseCollisionDetection = true
        ballNode.physicsBody?.categoryBitMask = UInt32(CollisionCategoryBitMask.Person)
        ballNode.physicsBody?.collisionBitMask = UInt32(CollisionCategoryBitMask.Platform)
        ballNode.physicsBody?.contactTestBitMask = UInt32(CollisionCategoryBitMask.Platform)
        //Adds image to the ball
        let sprite = SKSpriteNode(imageNamed: "test")
        sprite.size = CGSize(width: 10, height: 10)
        ballNode.addChild(sprite)
        
        
        return ballNode
    }
    
    func createPlatform(position: CGPoint, ofType type: PlatformType) -> PlatfromNode {
        
        let node = PlatfromNode()
        node.position = CGPoint(x: position.x, y: position.y)
        node.name = "NODE_PLATFORM"
        node.platfromType = type
        
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
    
    func createStartingPlatform(ofType type: PlatformType) -> PlatfromNode {
        
        let node = PlatfromNode()
        node.position = CGPoint(x: size.width * 0.5, y: size.height * 0.17)
        node.name = "STARING_PLATFORM"
        node.platfromType = type
        
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
        joint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: point)
        self.physicsWorld.add(joint)
        
    }
    
    //Attaches ball to platfrom on contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA
        let nodeB = contact.bodyB
        
        impulseVector = CGVector(dx: contact.contactPoint.x, dy: contact.contactPoint.y)
        touch = true
        
        if nodeA.categoryBitMask == UInt32(CollisionCategoryBitMask.Person) && nodeB.categoryBitMask == UInt32(CollisionCategoryBitMask.Platform){
            self.joinPhysicsBodies(bodyA: nodeA, bodyB: nodeB, point:contact.contactPoint)
        }
        if nodeA.categoryBitMask == UInt32(CollisionCategoryBitMask.Platform) && nodeB.categoryBitMask == UInt32(CollisionCategoryBitMask.Person){
            self.joinPhysicsBodies(bodyA: nodeA, bodyB: nodeB, point:contact.contactPoint)
        }
    }

}
