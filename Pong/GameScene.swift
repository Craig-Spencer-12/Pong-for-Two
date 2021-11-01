//
//  GameScene.swift
//  Pong
//
//  Created by Craig on 5/26/19.
//  Copyright © 2019 Craig. All rights reserved.
//

import SpriteKit
import GameplayKit

//var pauseMenu = false

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Sprite instance variables
    var b = SKSpriteNode()
    var p1 = SKSpriteNode()
    var p2 = SKSpriteNode()
    
    var l1 = SKLabelNode()
    var l2 = SKLabelNode()
    
    var menuButton1 = SKLabelNode()
    var menuButton2 = SKLabelNode()
    var reset = SKLabelNode()
    var resume = SKLabelNode()
    
    //Numeric instance variables
    var score = [Int]()
    let cpuLevel = 0.4 - difficulty/3
    var twoPlayer = gameType
    var firstTouch = true

    //Adjustable instance variables
    let playerSpeed = 0.15
    let initSpeed = 25.0
    var num = 8.0
    let winScore = 7
    
    //Defines physics categories
    struct PhysicsCategory {
        static let ball: UInt32 = 0x1 << 0
        static let paddle: UInt32 = 0x1 << 1
    }
    
    override func didMove(to view: SKView) {
        
        //SpritNode definitions
        b = self.childNode(withName: "Ball") as! SKSpriteNode
        p1 = self.childNode(withName: "Paddle1") as! SKSpriteNode
        p2 = self.childNode(withName: "Paddle2") as! SKSpriteNode
        l1 = self.childNode(withName: "P1_Score") as! SKLabelNode
        l2 = self.childNode(withName: "P2_Score") as! SKLabelNode
        menuButton1 = self.childNode(withName: "menuReturn1") as! SKLabelNode
        menuButton2 = self.childNode(withName: "menuReturn2") as! SKLabelNode
        reset = self.childNode(withName: "reset") as! SKLabelNode
        resume = self.childNode(withName: "resume") as! SKLabelNode
        
        //Physics definitions
        self.physicsWorld.contactDelegate = self
        
        b.physicsBody?.categoryBitMask = PhysicsCategory.ball
        b.physicsBody?.collisionBitMask = PhysicsCategory.paddle
        b.name = "Ball"
        
        p1.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        p1.physicsBody?.collisionBitMask = PhysicsCategory.ball
        p1.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        p1.name = "Paddle1"
        
        p2.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        p2.physicsBody?.collisionBitMask = PhysicsCategory.ball
        p2.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        p2.name = "Paddle2"
        
        //Defines the borders of the game
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 0
        self.physicsBody = border
        
        //Prepares the scene
        showButtons(on: false)
    }
    
    //Sets the score to 0 - 0 and places the ball in the center
    func startGame() {
        //Resets score
        score = [0,0]
        l1.text = "\(score[0])"
        l2.text = "\(score[1])"
        l1.zRotation = 0
        l2.zRotation = 3.1415
        
        //Resets velocity and position
        centerBall()
        b.physicsBody?.applyImpulse(initVelocity(isNeg: false))
    }
    
    //Places the ball in the center with 0 velocity
    func centerBall() {
        b.position = CGPoint(x: 0, y: 0)
        b.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        num = 8
    }
    
    //Pauses the game
    func pause() {
                centerBall()
        pauseMenu = true
                showButtons(on: true)
                }
    
    func unpause() {
        b.physicsBody?.applyImpulse(initVelocity(isNeg: false))
        pauseMenu = false
        showButtons(on: false)
    }
    
    func showButtons(on: Bool) {
        if on {
            menuButton1.isHidden = false
            menuButton2.isHidden = false
            reset.isHidden = false
            resume.isHidden = false
        }
        else {
            menuButton1.isHidden = true
            menuButton2.isHidden = true
            reset.isHidden = true
            resume.isHidden = true
        }
    }
    
    //Gives a point to the winner and resets the ball
    func addScore(player: SKSpriteNode) {
        centerBall()
        
        if player == p1{
            score[0] += 1
            b.physicsBody?.applyImpulse(initVelocity(isNeg: true))
        }
        else if player == p2 {
            score[1] += 1
            b.physicsBody?.applyImpulse(initVelocity(isNeg: false))
        }
        
        l1.text = "\(score[0])"
        l2.text = "\(score[1])"
        
        //Win condition
        if score[0] >= winScore {
            centerBall()
            l2.text = "Player 1"
            l1.text = "Wins"
            l2.zRotation = 0
        }
        else if score[1] >= winScore {
            centerBall()
            l2.text = "CPU"
            l1.text = "Wins"
            l2.zRotation = 0
            
            if twoPlayer {
                l2.text = "Wins"
                l1.text = "Player 2"
                l1.zRotation = 3.1415
                l2.zRotation = 3.1415
            }
        }
    }
    
    //Creates a random angle for the ball to be launched at
    func initVelocity(isNeg: Bool) -> CGVector {
        let angle = Double(Double(arc4random_uniform(20944)) / 10000.0 + 0.52359)
        var x = initSpeed * cos(angle), y = initSpeed * sin(angle)
        
        //Launches ball torwards the previous winner
        if isNeg {
            y *= -1
        }
        
        return CGVector(dx: x, dy: y)
    }
    
    //Collision handler
    func didBegin(_ contact: SKPhysicsContact) {
        
        let obj = contact.bodyB.node as! SKSpriteNode
        
        //if contact.bodyA.node!.name == nil {}         tests if the ball hit the wall
        
        if obj == p1 || obj == p2 {
            
            //speed up the ball
            b.physicsBody?.velocity.dx *= CGFloat(1.0 + 1.0/num)
            b.physicsBody?.velocity.dy *= CGFloat(1.0 + 1.0/num)
            
            //change the balls direction a bit
            let dx = Int(arc4random_uniform(15) + 5)
            let x = Double((b.physicsBody?.velocity.dx)!)
            let y = Double((b.physicsBody?.velocity.dy)!)
            
            if x > 2.7*abs(y) {
               b.physicsBody?.applyImpulse(CGVector(dx: -dx, dy: 0))
            }
            else {
                b.physicsBody?.applyImpulse(CGVector(dx: dx, dy: 0))
            }
            
            //increment num
            num += 1
        }
    }
    
    //Tap handler
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.y < -100{
                p1.run(SKAction.moveTo(x: location.x, duration: playerSpeed))
            }
            else if location.y > 100 && twoPlayer{
                p2.run(SKAction.moveTo(x: location.x, duration: playerSpeed))
            }
            else if location.y > -75 && location.y < 75 && !pauseMenu{
                if firstTouch {
                    startGame()
                    firstTouch = false
                }
                else {
                    pause()
                }
            }
            
            //determines the actions within the pause menu
            if pauseMenu {
                if location.x > -340 && location.x < -150 && location.y > 500 && location.y < 640 {
                    //return to main menu
                }
                else if location.x > -220 && location.x < -105 && location.y > -140 && location.y < -85 {
                    //reset
                    unpause()
                    startGame()
                }
                else if location.x > 65 && location.x < 250 && location.y > -140 && location.y < -85 {
                    //resume
                    unpause()
                }
            }
        }
    }
    
    //Press handler
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.y < -100{
                p1.run(SKAction.moveTo(x: location.x, duration: playerSpeed))
            }
            else if location.y > 100 && twoPlayer{
                p2.run(SKAction.moveTo(x: location.x, duration: playerSpeed))
            }
        }
    }

    //Frame by frame functions
    override func update(_ currentTime: TimeInterval) {
        
        if !twoPlayer {
            p2.run(SKAction.moveTo(x: b.position.x, duration: TimeInterval(cpuLevel)))
        }
        
        if b.position.y < p1.position.y - 130 {
            addScore(player: p2)
        }
        else if b.position.y > p2.position.y + 130 {
            addScore(player: p1)
        }
    }
}
