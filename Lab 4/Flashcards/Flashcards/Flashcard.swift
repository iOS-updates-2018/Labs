//
//  Flashcard.swift
//  Flashcards
//
//  Created by Jordan Stapinski on 1/27/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import Foundation

struct Flashcard {
  var command: String
  var definition: String
  
  init(command: String, definition: String){
    self.command = command
    self.definition = definition
  }
}
