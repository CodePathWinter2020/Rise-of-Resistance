//
//  GameScene.swift
//  Rise of Resistance
//
//  Created by Hung Phan on 3/9/20.
//  Copyright © 2020 Hung Phan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneZot: SKScene, SKPhysicsContactDelegate {

    var playerShip : SKSpriteNode!
    var scoreLabel : SKLabelNode!
    var score : Int = 0 {
        // didSet updates scoreLabel when score is changed
        // aka lazy load
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var photonTorpedoCategory : UInt32 = 0x1 << 0
    var alienCategory : UInt32 = 0x1 << 1
    var playerShipCategory : UInt32 = 0x1 << 2
    var gameTimer : Timer!
    var shooting = false
    var lastShootingTime : TimeInterval = 0
    var delayBetweenShots : TimeInterval = 0.1
    var firstCorrectTouch = false
    var possibleAliens = ["alien1", "alien2", "alien3", "alien4", "alien5", "alien6", "alien7", "alien8", "alien9", "alien10", "alien11", "alien12"]
    
    override func didMove(to view: SKView) {
        
        // add SKPhysicsContactDelegate <- Very important, needed for didBegin and torpedoDidCollideWithAlien
        // used for detect bullets hitting the enemy ships
        self.physicsWorld.contactDelegate = self
        
        // add space background
       self.backgroundColor = SKColor.black
        let spaceBackground = SKEmitterNode(fileNamed: "SpaceBackground.sks")
        spaceBackground?.position = CGPoint(x: self.frame.width / 2, y: self.frame.size.height)
        spaceBackground?.zPosition = -20
        spaceBackground?.advanceSimulationTime(Double(spaceBackground!.particleLifetime))
        self.addChild(spaceBackground!)
        
        // add playerShip
        playerShip = SKSpriteNode(imageNamed: "uci")
        playerShip.name = "shuttle"
        playerShip.position = CGPoint(x: self.frame.size.width / 2, y: playerShip.size.height / 2 + 20)
        self.addChild(playerShip)
        playerShip.physicsBody = SKPhysicsBody(rectangleOf: playerShip.size)
        playerShip.physicsBody?.isDynamic = false
        playerShip.physicsBody?.categoryBitMask = playerShipCategory
        playerShip.physicsBody?.contactTestBitMask = alienCategory
        
        
        // add score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 80, y: self.frame.height - 70)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(165.0/255.0), blue: CGFloat(165.0/255.0), alpha: 1.0)
        score = 0
        self.addChild(scoreLabel)
        
        // add aliens every 0.3 seconds
        gameTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addAliens), userInfo: nil, repeats: true)
    
    }
    
    
    @objc func addAliens() {
        
        possibleAliens = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleAliens) as! [String]
        let alien = SKSpriteNode(imageNamed: possibleAliens[0])
        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.frame.size.width))
        let position = CGFloat(randomAlienPosition.nextInt())
        alien.position = CGPoint(x: position, y: self.frame.size.height + alien.size.height)
        alien.physicsBody = SKPhysicsBody(rectangleOf: alien.size)
        alien.physicsBody?.isDynamic = true
        alien.physicsBody?.categoryBitMask = alienCategory
        alien.physicsBody?.contactTestBitMask = photonTorpedoCategory | playerShipCategory
        alien.physicsBody?.collisionBitMask = 0
        self.addChild(alien)
        
        let animationDuration : TimeInterval = 6
        var actionArray = [SKAction]()
        // y: -alien.size.height => leaves the screen at the bottom of iphone
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -alien.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        alien.run(SKAction.sequence(actionArray))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = (touch?.location(in: self))!
        
        for touchedNode in self.nodes(at: location) {
            if touchedNode.name == "shuttle" {
                self.shooting = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)

        for touchedNode in self.nodes(at: location) {
            if touchedNode.name == "shuttle" {
                firstCorrectTouch = true
            }
            
            if firstCorrectTouch {
                playerShip.position.x = location.x
                playerShip.position.y = location.y
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.shooting = false
    }
    
    func fireTopedo() {
        self.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = playerShip.position
        let radius = torpedoNode.size.width / 2
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        torpedoNode.physicsBody?.isDynamic = true
        torpedoNode.physicsBody?.categoryBitMask = photonTorpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(torpedoNode)
        
        let animationDuration : TimeInterval = 0.1
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: playerShip.position.x, y: self.frame.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
    }
    
    // delegate method from SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        let collison : UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collison == playerShipCategory | alienCategory {
//            print("Yesss\n");
            playerShipDidCollideWithAlien()
        }
        if collison == photonTorpedoCategory | alienCategory {
//            print("Noooon");
            // find out which body is alien or torpedo
            var firstBody : SKPhysicsBody
            var secondBody : SKPhysicsBody

            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            torpedoDidCollideWithAlien(torpedoNode: firstBody.node as! SKSpriteNode, alienNode: secondBody.node as! SKSpriteNode)
        }
    }
    
    func playerShipDidCollideWithAlien() {
//        print("player touches alien\n");
        let transition = SKTransition.flipVertical(withDuration: 0.5)
        let gameOver = GameOver(fileNamed: "GameOver")
        gameOver?.gameOverScore = score
        self.view?.presentScene(gameOver!, transition: transition)
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        self.addChild(explosion)
        
        self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
        
        score += 5
    }
    
    override func update(_ currentTime: TimeInterval) {
        if shooting {
            let delay = currentTime - lastShootingTime
            if delay >= delayBetweenShots {
                fireTopedo()
                lastShootingTime = currentTime
            }
        }
    }

}

