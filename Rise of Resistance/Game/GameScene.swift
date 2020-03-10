//
//  GameScene.swift
//  Rise of Resistance
//
//  Created by Hung Phan on 3/9/20.
//  Copyright © 2020 Hung Phan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var playerShip : SKSpriteNode!
    var scoreLabel : SKLabelNode!
    var score : Int = 0 {
        // didSet updates scoreLabel when score is changed
        // aka lazy load
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        // add space background
       self.backgroundColor = SKColor.black
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground.sks")
        spaceBackground?.position = CGPoint(x: self.frame.width / 2, y: self.frame.size.height)
        spaceBackground?.zPosition = -20
    spaceBackground?.advanceSimulationTime(Double(spaceBackground!.particleLifetime))
        self.addChild(spaceBackground!)
        
        // add playerShip
        playerShip = SKSpriteNode(imageNamed: "shuttle")
        playerShip.name = "shuttle"
        playerShip.position = CGPoint(x: self.frame.size.width / 2, y: playerShip.size.height / 2 + 20)
        self.addChild(playerShip)
        
        
        // add score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: self.frame.height - 70)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(165.0/255.0), blue: CGFloat(165.0/255.0), alpha: 1.0)
        score = 0
        self.addChild(scoreLabel)
        
    }
//
//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

