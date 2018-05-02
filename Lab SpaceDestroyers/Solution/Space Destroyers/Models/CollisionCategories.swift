//
//  CollisionCategories.swift
//  Space Destroyers
//
//  Created by Jordan Stapinski on 5/1/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import Foundation

struct CollisionCategories{
  static let Invader : UInt32 = 0x1 << 0
  static let Player: UInt32 = 0x1 << 1
  static let InvaderBullet: UInt32 = 0x1 << 2
  static let PlayerBullet: UInt32 = 0x1 << 3
  static let EdgeBody: UInt32 = 0x1 << 4
}
