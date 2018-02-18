//
//  Contact.swift
//  ContactsAdvanced
//
//  Created by Jordan Stapinski on 2/17/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import Foundation
import UIKit


class Contact: NSObject {
  
  // MARK: - Properties
  var name: String = "Batman"  // Let's be honest, we all want Batman as a contact
  var email: String?
  var homePhone: String?
  var workPhone: String?
  var picture: UIImage?
  
  // MARK: - General
  
  override init() {
    super.init()
  }
  
}
