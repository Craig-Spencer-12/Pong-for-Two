//
//  GameViewController.swift
//  Pong
//
//  Created by Craig on 5/26/19.
//  Copyright © 2019 Craig. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

//Global variables
var gameType = true
var difficulty = Float(0.7)
var pauseMenu = false

class GameViewController: UIViewController {
    
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    @IBAction func returnToMenuButton(_ sender: Any) {
        if pauseMenu {
            let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! PongMenu
            
            self.navigationController?.pushViewController(menuVC, animated: true)
            
            pauseMenu = false
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
