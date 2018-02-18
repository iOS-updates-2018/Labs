//
//  DetailViewController.swift
//  ContactsAdvanced
//
//  Created by Jordan Stapinski on 2/17/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var homePhoneLabel: UILabel!
  @IBOutlet weak var workPhoneLabel: UILabel!
  @IBOutlet weak var imageLabel: UIImageView!
  
  
  var detailItem: Contact? {
    didSet {
      // Update the view.
      self.configureView()
    }
  }
  
  func configureView() {
    // Update the user interface for the detail item.
    if let detail: Contact = self.detailItem {
      if let name = self.nameLabel {
        name.text = detail.name
      }
      if let email = self.emailLabel {
        email.text = detail.email
      }
      if let homePhone = self.homePhoneLabel {
        homePhone.text = detail.homePhone
      }
      if let workPhone = self.workPhoneLabel {
        workPhone.text = detail.workPhone
      }
      if let image = self.imageLabel {
        image.image = detail.picture
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
