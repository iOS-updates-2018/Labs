//
//  AddContactController.swift
//  ContactsAdvanced
//
//  Created by Jordan Stapinski on 2/17/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit
import Photos
import CoreData


// MARK: Protocol Methods

protocol AddContactControllerDelegate: class {
  func addContactControllerDidCancel(controller: AddContactController)
  
  func addContactController(controller: AddContactController, didFinishAddingContact contact: Contact)
}


// MARK: - AddContactController

class AddContactController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // MARK: - Outlets
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var homePhoneField: UITextField!
  @IBOutlet weak var workPhoneField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var picPreview: UIImageView!
  
  let imagePicker = UIImagePickerController()
  var picture: UIImage?
  
  
  // MARK: - Properties
  weak var delegate: AddContactControllerDelegate?
  
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    PHPhotoLibrary.requestAuthorization({_ in return})
    imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nameField.becomeFirstResponder()
  }
  
  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.addContactControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    let contact = Contact()
    contact.name = nameField.text!
    contact.email = emailField.text
    contact.homePhone = homePhoneField.text
    contact.workPhone = workPhoneField.text
    contact.picture = picture
    self.saveContact(contact: contact)
    delegate?.addContactController(controller: self, didFinishAddingContact: contact)
  }
  
  func saveContact(contact: Contact){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
    let newUser = NSManagedObject(entity: entity!, insertInto: context)
    newUser.setValue(contact.email, forKey: "email")
    newUser.setValue(contact.name, forKey: "name")
    newUser.setValue(contact.homePhone, forKey: "home_phone")
    newUser.setValue(contact.workPhone, forKey: "work_phone")
    if let pic = contact.picture {
      newUser.setValue(UIImagePNGRepresentation(pic), forKey: "photo")
    }
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
  }
  
  
  // MARK: - Table View
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
  
  // MARK: - Text Field Delegate
  
  func textField(_ nameField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let oldText: NSString = nameField.text! as NSString
    let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString
    
    doneBarButton.isEnabled = (newText.length > 0)
    return true
  }
  

  @IBAction func loadImageButtonTapped(sender: UIButton) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      picture = pickedImage
      picPreview.image = picture
    }
    
    dismiss(animated: true, completion: nil)
  }
  
}
