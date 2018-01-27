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
  var flashcard: Flashcard?
  
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
  
  // because we really want a new card every time this view appears
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let flashcard = deck.drawRandomCard() {
      self.flashcard = flashcard
      commandLabel?.text = flashcard.command
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDefinition" {
      let showDefinition:DefinitionViewController = segue.destination as! DefinitionViewController
      showDefinition.flashcard = self.flashcard
    }
  }


}

