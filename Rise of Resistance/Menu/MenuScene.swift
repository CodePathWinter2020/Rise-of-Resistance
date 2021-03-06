//
//  MenuScene.swift
//  Rise of Resistance
//
//  Created by Hung Phan on 3/9/20.
//  Copyright © 2020 Hung Phan. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var mapLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground.sks")
        spaceBackground?.position = CGPoint(x: 0, y: self.frame.size.height)
        spaceBackground?.zPosition = -20
        spaceBackground?.advanceSimulationTime(Double(spaceBackground!.particleLifetime))
        self.addChild(spaceBackground!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        mapLabel = self.childNode(withName: "mapLabel") as! SKLabelNode
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameBtn" {
                if mapLabel.text == "Map: Original" {
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameScene = GameScene(size: self.size)
                    self.view?.presentScene(gameScene, transition: transition)
                }
                else {
                    let transition = SKTransition.flipVertical(withDuration: 0.5)
                    let gameSceneZot = GameSceneZot(size: self.size)
                    self.view?.presentScene(gameSceneZot, transition: transition)
                }

            }
            else if nodesArray.first?.name == "changeMapBtn" {
                if mapLabel.text == "Map: Original" {
                    mapLabel.text = "Map: Zot (Hard)"
                }
                else {
                    mapLabel.text = "Map: Original"
                }
            }
        }
    }
}
