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
        backgroundColor = UIColor.redColor()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let newScene = GameScene(size: size)
        newScene.scaleMode = scaleMode
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        self.view?.presentScene(newScene, transition: reveal)
    }
    
   }