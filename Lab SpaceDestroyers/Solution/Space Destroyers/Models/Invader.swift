//
//  Invader.swift
//  Space Destroyers
//
//  Created by Jordan Stapinski on 4/30/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit
import SpriteKit

class Invader: SKSpriteNode {
  // we will determine the invader's row/column later, set to (0,0) for now
  var invaderRow = 0
  var invaderColumn = 0
  
  init() {
    // we have three types of invader images so randomly chose among these
    let randNum = Int(arc4random_uniform(3) + 1)
    let texture = SKTexture(imageNamed: "invader\(randNum)")
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    self.name = "invader"
    
    // preparing invaders for collisions once we add physics...
    self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
    self.physicsBody?.isDynamic = true
    self.physicsBody?.usesPreciseCollisionDetection = false
    self.physicsBody?.categoryBitMask = CollisionCategories.Invader
    self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet | CollisionCategories.Player
    self.physicsBody?.collisionBitMask = 0x0
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    // SKSpriteNode conforms to NSCoding, which requires we implement this, but we can just call super.init()
    super.init(coder: aDecoder)
  }
  
  
  func fireBullet(scene: SKScene){
    let bullet = InvaderBullet(imageName: "laser", bulletSound: nil)
    bullet.position.x = self.position.x
    bullet.position.y = self.position.y - self.size.height/2
    scene.addChild(bullet)
    let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 2.0)
    let removeBulletAction = SKAction.removeFromParent()
    bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
  }
}
