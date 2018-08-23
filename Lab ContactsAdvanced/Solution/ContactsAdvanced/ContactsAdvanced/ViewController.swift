//
//  ViewController.swift
//  ContactsAdvanced
//
//  Created by Jordan Stapinski on 2/15/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, AddContactControllerDelegate {
  var contacts = [Contact]()
  let test = "Test"
  
  
  // MARK: - General
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.leftBarButtonItem = self.editButtonItem
    tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "cust_cell")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        self.loadContacts(data: data)
        print(data.value(forKey: "name") as! String)
      }
      
    } catch {
      
      print("Failed")
    }

  }
  
  func loadContacts(data: NSManagedObject){
    let newContact = Contact()
    newContact.name = data.value(forKey: "name") as! String
    newContact.email = (data.value(forKey: "email") as! String)
    newContact.homePhone = (data.value(forKey: "home_phone") as! String)
    newContact.workPhone = (data.value(forKey: "work_phone") as! String)
    newContact.picture = UIImage(data:(data.value(forKey: "photo") as! NSData) as Data, scale:1.0)
    contacts.append(newContact)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Segues
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let contact = contacts[indexPath.row]
        (segue.destination as! DetailViewController).detailItem = contact
      }
    } else if segue.identifier == "addContact" {
      let navigationController = segue.destination as! UINavigationController
      let controller = navigationController.topViewController as! AddContactController
      controller.delegate = self
    }
  }
  
  // MARK: - Table View
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cust_cell", for: indexPath as IndexPath) as! ContactTableViewCell
    
    let contact = contacts[indexPath.row]
    cell.nameLabel!.text = contact.name
    cell.userImage!.image = contact.picture
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
      request.returnsObjectsAsFaults = false
      do {
        let result = try context.fetch(request)
        for data in result as! [NSManagedObject] {
          if contacts[indexPath.row].name == (data.value(forKey: "name") as! String) &&
            contacts[indexPath.row].email == (data.value(forKey: "email") as! String) &&
            contacts[indexPath.row].homePhone == (data.value(forKey: "home_phone") as! String) &&
            contacts[indexPath.row].workPhone == (data.value(forKey: "work_phone") as! String){
            context.delete(data)
            try context.save()
          }
        }
      } catch {
        print("Failed")
      }
      contacts.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array,
      // and add a new row to the table view. However, not strictly needed here
      // given the segue automatically goes to add contact.
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "showDetail", sender: tableView)
  }
  
  // MARK: - Delegate protocols
  
  func addContactControllerDidCancel(controller: AddContactController) {
    dismiss(animated: true, completion: nil)
  }
  
  func addContactController(controller: AddContactController, didFinishAddingContact contact: Contact) {
    let newRowIndex = contacts.count
    
    contacts.append(contact)
    
    let indexPath = NSIndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
    
    dismiss(animated: true, completion: nil)
  }



}

