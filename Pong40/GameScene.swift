//
//  GameScene.swift
//  Pong40
//
//  Created by ljvis42 on 26-02-15.
//  Copyright (c) 2015 GoudVis. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var BallCategoryName = "ball"
    var PaddleCategoryName = "paddle"
    var BottomCategoryName = "bottom"
    
    let BallCategory    : UInt32 = 0x1 << 0
    let BottomCategory  : UInt32 = 0x1 << 1
    let PaddleCategory  : UInt32 = 0x1 << 3
    
    
    var startButton: UIButton!
    var isRunning = true
    var score = 0
    var scoreLabel = SKLabelNode()
    
    var ball = SKSpriteNode()
    var paddle = SKSpriteNode()
    var bottom = SKSpriteNode()
    
    var isFingerOnPaddle = false

    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.gravity = CGVectorMake(0,0)
        physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor.blackColor()
        
       
        scoreLabel.fontColor = UIColor.whiteColor()
        scoreLabel.fontName = "Avenir"
        scoreLabel.fontSize = 25
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(frame) + 150, CGRectGetMidY(frame))
        addChild(scoreLabel)
        
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        borderBody.angularDamping = 0
        borderBody.linearDamping = 0
        self.physicsBody = borderBody
        
        var paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.xScale = 0.7
        paddle.yScale = 0.7
        paddle.name = "paddle"
        paddle.position = CGPoint(x: frame.size.width/2, y: 50)
        addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.size)
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody?.angularDamping = 0
        paddle.physicsBody?.linearDamping = 0
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.dynamic = false
        
        let bottom = SKSpriteNode(imageNamed: "paddle")
        bottom.position = CGPointMake(frame.width/2, 0)
        bottom.size.width = frame.width
        bottom.size.height = 10
        bottom.name = "bottom"
        bottom.hidden = true
        addChild(bottom)
        
        bottom.physicsBody = SKPhysicsBody(rectangleOfSize: bottom.size)
        bottom.physicsBody?.dynamic = false
        bottom.physicsBody?.restitution = 1
        bottom.physicsBody?.linearDamping = 0
        bottom.physicsBody?.angularDamping = 0
        bottom.physicsBody?.friction = 0
        
        
        bottom.physicsBody?.categoryBitMask = BottomCategory
        paddle.physicsBody?.categoryBitMask = PaddleCategory
        
        runAction((SKAction.sequence([SKAction.waitForDuration(1),SKAction.runBlock(spawnBall)])))
      
       
    }
    func wait() {
        SKAction.waitForDuration(2)
    }

    func random(x: Int) -> CGFloat {
         var y: CGFloat = CGFloat(arc4random_uniform(UInt32(x)))
         return y
    }
    
    
    func spawnBall() {
        
        
        ball = SKSpriteNode(imageNamed: "bal")
        ball.xScale = 0.4
        ball.yScale = 0.4
        ball.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(ball)
        
        ball.name = "ball"
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.1)
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.friction = 0
        
        ball.physicsBody?.applyImpulse(CGVectorMake(8 + random(7), 15 + random(15)))
        
        ball.physicsBody?.categoryBitMask = BallCategory
        ball.physicsBody?.contactTestBitMask = BottomCategory
       
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
       for touch: AnyObject in touches {
           let location = touch.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(location) {
            if body.node?.name == PaddleCategoryName {
                isFingerOnPaddle = true
               
            }
          }
       }
    }
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        isFingerOnPaddle = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        let ball = childNodeWithName(BallCategoryName) as SKSpriteNode
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            
            ball.physicsBody?.velocity = CGVectorMake(0, 0)
            ball.removeFromParent()
            score++
            scoreLabel.text = String(score)
            isRunning = false

            runAction((SKAction.sequence([SKAction.waitForDuration(1),SKAction.runBlock(spawnBall)])))
           
            if score >= 10 {
                
                let gameOverScene = GameOverScene(size: size)
                gameOverScene.scaleMode = scaleMode
                let reveal = SKTransition.flipHorizontalWithDuration(0.7)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if isFingerOnPaddle {
            var touch = touches.anyObject() as UITouch
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            var paddle = childNodeWithName(PaddleCategoryName) as SKSpriteNode
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
    }
}
