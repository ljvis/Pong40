//
//  GameOverScene.swift
//  Pong40
//
//  Created by ljvis42 on 27-02-15.
//  Copyright (c) 2015 GoudVis. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.grayColor()
        
        let myLabel = SKLabelNode(fontNamed:"Avenir")
        myLabel.text = "Game Over!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)

        let wait = SKAction.waitForDuration(3)
        let block = SKAction.runBlock {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene, transition:reveal)
            
        }
        self.runAction(SKAction.sequence([wait,block]))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let newScene = GameScene(size: size)
         newScene.scaleMode = scaleMode
        let reveal = SKTransition.flipHorizontalWithDuration(1)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
   }