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
    let BALL_RADIUS: CGFloat = 12.9
    let BALL_SPEED: CGFloat = 10
    let ANCHOR_RADIUS: CGFloat = 58

    //member variables
    var ballIsOnPlatform = false
    var platformGenerator: PlatformGenerator!
    var currentPlatform: SKNode?
    var ball: SKShapeNode!
    var border: SKPhysicsBody!
    //var platformThreshold: SKPhysicsBody!
    var joint = SKPhysicsJointFixed()
    
    var isStarted = false
    var isGameOver = false
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.lightGray
        
        addPhysicsWorld()
        addBorder()
        //addPlatformThreshold()
        addPlatformGenerator()
        platformGenerator.generateStartScreenPlatforms()
        addBall()
        addScoreLabels()
        loadHighscore()
        addTapToStartLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if isGameOver {
            restart()
        } else if !isStarted {
            start()
        }
        
        if !ballIsOnPlatform
        {
            return
        }
        
        scene?.physicsWorld.remove(joint)
        ballIsOnPlatform = false
        
        // Calculate vector components x and y
        var dx: CGFloat = ball.position.x - (currentPlatform?.position.x)!
        var dy: CGFloat = ball.position.y - (currentPlatform?.position.y)!
        
        // Normalize the components
        let magnitude = sqrt(dx*dx+dy*dy)
        dx /= magnitude
        dy /= magnitude
        
        let dir = CGVector(dx: dx * BALL_SPEED, dy: dy * BALL_SPEED)
        
        ball.physicsBody?.applyImpulse(dir)
        
    }
    
    //contact between two PhysicsBodys occurred
    func didBegin(_ contact: SKPhysicsContact)
    {
        let nodeA = contact.bodyA.categoryBitMask
        let nodeB = contact.bodyB.categoryBitMask
        
        if nodeA == CollisionCategoryBitMask.PlatformThreshold ||
            nodeB == CollisionCategoryBitMask.PlatformThreshold
        {
            gameOver()
        }
        
        if nodeA == CollisionCategoryBitMask.Border
        {
            gameOver()
        }
        
        if nodeA == CollisionCategoryBitMask.Platform
        {
            if currentPlatform != contact.bodyA
            {
                let a = ball.position.x - contact.bodyA.node!.position.x
                let b = ball.position.y - contact.bodyA.node!.position.y
                let c = sqrt(a*a+b*b)
                
                let magnitude: CGFloat = ANCHOR_RADIUS/c
                
                //print("orig: ",(c), " new: ",(sqrt(a*a*magnitude*magnitude+b*b*magnitude*magnitude)))
                
                let anchor = CGPoint(x: (contact.bodyA.node?.position.x)! + a*magnitude,
                                     y: (contact.bodyA.node?.position.y)! + b*magnitude)
                
                ball.position = anchor
                joinPhysicsBodies(bodyA: contact.bodyA, bodyB: contact.bodyB, point:anchor)
                currentPlatform = contact.bodyA.node
                ballIsOnPlatform = true
                let scoreLabel = childNode(withName: "scoreLabel") as! ScoreLabel
                scoreLabel.increment()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        let bottomPlatform = platformGenerator.platforms.first
                
        if (bottomPlatform?.position.y)! + ANCHOR_RADIUS < 0
        {
            platformGenerator.removeBottomPlatform()
            platformGenerator.generateNextPlatform(movingLong: true, movingLat: true)
        }
    }
    
    func addPhysicsWorld()
    {
        physicsWorld.contactDelegate = self
    }
    
    func addBorder()
    {
        border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.categoryBitMask = CollisionCategoryBitMask.Border
        border.contactTestBitMask = CollisionCategoryBitMask.Ball
        border.collisionBitMask = 0
        self.physicsBody = border
    }
    
    //feel free to junk this function
    /*func addPlatformThreshold()
    {
        let padding = CGFloat(80)
        let ptSize = CGSize(width: size.width - 2*padding, height: size.height)
        let ptRect = CGRect(origin: CGPoint(x: size.width/2, y: size.height/2),
                            size: ptSize)
        platformThreshold = SKPhysicsBody(edgeLoopFrom: ptRect)
        platformThreshold.categoryBitMask = CollisionCategoryBitMask.PlatformThreshold
        platformThreshold.contactTestBitMask = CollisionCategoryBitMask.Platform
        platformThreshold.collisionBitMask = 0
    }*/
    
    func addPlatformGenerator()
    {
        platformGenerator = PlatformGenerator(color: UIColor.clear, size: view!.frame.size)
        addChild(platformGenerator)
    }
    
    func addBall()
    {
        ball = SKShapeNode(circleOfRadius: BALL_RADIUS)
        ball.fillColor = UIColor.white
        ball.strokeColor = UIColor.darkGray
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: BALL_RADIUS)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.categoryBitMask = CollisionCategoryBitMask.Ball
        ball.physicsBody?.contactTestBitMask = CollisionCategoryBitMask.Platform
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.affectedByGravity = false
        
        let startingPlat: Platform = platformGenerator.platforms[0]
        
        let x: CGFloat = size.width / 2
        let y: CGFloat = startingPlat.position.y + ANCHOR_RADIUS
        let anchor = CGPoint(x: x, y: y)
        
        ball.position = anchor
        
        addChild(ball)
        
        joinPhysicsBodies(bodyA: ball.physicsBody!, bodyB: startingPlat.physicsBody!, point: anchor)
        currentPlatform = startingPlat
        ballIsOnPlatform = true


    }
    
    func addScoreLabels()
    {
        //current score
        let scoreLabel = ScoreLabel(num: 0)
        scoreLabel.position = CGPoint(x: 35.0, y: view!.frame.size.height - 35)
        scoreLabel.name = "scoreLabel"
        addChild(scoreLabel)
        
        //high score
        let highscoreLabel = ScoreLabel(num: 0)
        highscoreLabel.name = "highscoreLabel"
        highscoreLabel.position = CGPoint(x: view!.frame.size.width - 35, y: view!.frame.size.height - 35)
        addChild(highscoreLabel)
        
        let highscoreTextLabel = SKLabelNode(text: "High")
        highscoreTextLabel.fontColor = UIColor.black
        highscoreTextLabel.fontSize = 14.0
        highscoreTextLabel.fontName = "Helvetica"
        highscoreTextLabel.position = CGPoint(x: 0, y: -20)
        highscoreLabel.addChild(highscoreTextLabel)
    }
    
    func loadHighscore() {
        let defaults = UserDefaults.standard
        
        let highscoreLabel = childNode(withName: "highscoreLabel") as! ScoreLabel
        highscoreLabel.setTo(defaults.integer(forKey: "highscore"))
    }

    func addTapToStartLabel()
    {
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + 40
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = UIColor.white
        tapToStartLabel.fontSize = 35.0
        addChild(tapToStartLabel)
        tapToStartLabel.run(blinkAnimation())
    }
    
    func start()
    {
        isStarted = true
        
        let tapToStartLabel = childNode(withName: "tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        
        for platform in platformGenerator.platforms
        {
            platform.startMovingLong()
        }
        
    }
    
    func restart()
    {
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene)
    }
    
    func gameOver()
    {
        isGameOver = true
        
        // stop everything
        for platform in platformGenerator.platforms
        {
            platform.stopActions()
        }
        
        // create game over label
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 40
        gameOverLabel.fontSize = 35.0
        addChild(gameOverLabel)
        gameOverLabel.run(blinkAnimation())
        
        // save current score label value
        let scoreLabel = childNode(withName: "scoreLabel") as! ScoreLabel
        let highscoreLabel = childNode(withName: "highscoreLabel") as! ScoreLabel
        
        if highscoreLabel.number < scoreLabel.number {
            highscoreLabel.setTo(scoreLabel.number)
            
            let defaults = UserDefaults.standard
            defaults.set(highscoreLabel.number, forKey: "highscore")
        }
    }
    
    func blinkAnimation() -> SKAction {
        let duration = 0.8
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
    }
    
    //function to attach nodes on contact
    func joinPhysicsBodies(bodyA:SKPhysicsBody, bodyB:SKPhysicsBody, point:CGPoint)
    {
        joint = SKPhysicsJointFixed.joint(withBodyA: bodyA, bodyB: bodyB, anchor: point)
        self.physicsWorld.add(joint)
    }
    
}
