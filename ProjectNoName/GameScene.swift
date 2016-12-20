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
    var ball: SKShapeNode!
    var foregroundNode: SKNode!
    var test = 1

    //Not sure what this is tbh lol
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    //Esentially out main() function
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

        if (ball.physicsBody?.isDynamic)!{
            return
        }
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 20.0))
        
    }
    
    //Player/ball function
    func createPlayer() -> SKShapeNode {
        
        let ball = SKShapeNode(circleOfRadius: 5)
        ball.strokeColor = SKColor.white
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        ball.fillColor = SKColor.white
        ball.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        
        return ball
    }

}
