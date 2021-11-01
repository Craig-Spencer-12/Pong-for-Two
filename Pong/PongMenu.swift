//
//  PongMenu.swift
//  Pong
//
//  Created by Craig on 5/27/19.
//  Copyright © 2019 Craig. All rights reserved.
//

import Foundation
import UIKit

class PongMenu: UIViewController {
    
    @IBOutlet weak var p1Button: UIButton!
    @IBOutlet weak var p2Button: UIButton!
    @IBOutlet weak var slider: UISlider!
    var p2 = false
    
    @IBAction func startButton(_ sender: Any) {
        gameType = p2
        difficulty = slider.value
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func gameMode(_ sender: UIButton) {
        if sender.tag == 1 {
            p2 = false
            p1Button.setTitleColor(UIColor.black, for: .normal)
            p2Button.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            p2 = true
            p1Button.setTitleColor(UIColor.white, for: .normal)
            p2Button.setTitleColor(UIColor.black, for: .normal)
        }
    }
}
