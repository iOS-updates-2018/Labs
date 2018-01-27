//
//  DefinitionViewController.swift
//  Flashcards
//
//  Created by Jordan Stapinski on 1/27/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit

class DefinitionViewController: UIViewController {
  
  @IBOutlet weak var commandLabel: UILabel?
  @IBOutlet weak var definitionLabel: UILabel?
  
  var flashcard: Flashcard?

    override func viewDidLoad() {
        super.viewDidLoad()
        // we need to safely unpack the flashcard and display the data, if present
        if let card = flashcard {
          commandLabel?.text = card.command
          definitionLabel?.text = card.definition
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
