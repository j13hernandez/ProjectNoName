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

class GameScene: SKScene {

    //Global variables
    var ball = SKNode()
    var foregroundNode = SKNode()

    //Not sure what this is tbh lol
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    //Esentially our main() function
    override init(size: CGSize){
        
        super.init(size: size)
        //Gravity for our universe
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        backgroundColor = SKColor.black
        //Add Moving Layer
        foregroundNode = SKNode()
        addChild(foregroundNode)
        
        //Add Player
        ball = createPlayer()
        foregroundNode.addChild(ball)
    }
    

    //Should push our ball up. I think it's not because our ball doesnt have a platform to push off
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if (ball.physicsBody!.isDynamic){
            return
        }
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 2.0))
        
    }
    
    //Player/ball create function
    func createPlayer() -> SKNode {
        
        //creates ball node
        let ballNode = SKNode()
        //physics body so that gravity affects it
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        ballNode.physicsBody?.isDynamic = false
        ballNode.physicsBody?.allowsRotation = false
        ballNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
        //Adds image to the ball
        let sprite = SKSpriteNode(imageNamed: "whiteCircle")
        sprite.size = CGSize(width: 10, height: 10)
        ballNode.addChild(sprite)
        
        return ballNode
    }

}
