//
//  ContactTableViewCell.swift
//  ContactsAdvanced
//
//  Created by Jordan Stapinski on 2/16/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
