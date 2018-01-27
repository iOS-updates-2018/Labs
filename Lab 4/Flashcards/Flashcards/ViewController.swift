//
//  ViewController.swift
//  Flashcards
//
//  Created by Jordan Stapinski on 1/27/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let deck = Deck()
  var flashcard: Flashcard? = nil
  
  @IBOutlet weak var commandLabel: UILabel?

  override func viewDidLoad() {
    super.viewDidLoad()
    if let flashcard = deck.drawRandomCard() {
      self.flashcard = flashcard
      commandLabel?.text = flashcard.command
    }
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

