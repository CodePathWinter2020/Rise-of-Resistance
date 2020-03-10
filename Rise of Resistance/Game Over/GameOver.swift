//
//  GameOver.swift
//  Rise of Resistance
//
//  Created by Hung Phan on 3/9/20.
//  Copyright © 2020 Hung Phan. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    var gameOverScore : Int = 0
    var scoreLabel : SKLabelNode!
    var gameSceneZot : Bool = false
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground.sks")
        spaceBackground?.position = CGPoint(x: self.frame.width / 2, y: self.frame.size.height)
        spaceBackground?.zPosition = -20
        spaceBackground?.advanceSimulationTime(Double(spaceBackground!.particleLifetime))
        self.addChild(spaceBackground!)
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "\(gameOverScore)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameBtn" {
                if gameSceneZot {
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameSceneZot(size: self.size)
                    self.view?.presentScene(gameScene, transition: transition)
                }
                else {
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameScene(size: self.size)
                    self.view?.presentScene(gameScene, transition: transition)
                }
            }
            else if nodesArray.first?.name == "mainMenuBtn" {
                let transition = SKTransition.flipVertical(withDuration: 0.5)
                let menuScene = MenuScene(fileNamed: "MenuScene")
                self.view?.presentScene(menuScene!, transition: transition)
            }
        }
    }
}
