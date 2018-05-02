//
//  GameViewController.swift
//  Space Destroyers
//
//  Created by Jordan Stapinski on 4/30/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      let scene = StartGameScene(size: view.bounds.size)
      let skView = view as! SKView
      skView.showsFPS = true
      skView.showsNodeCount = true
      skView.ignoresSiblingOrder = true
      scene.scaleMode = .resizeFill
      skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
