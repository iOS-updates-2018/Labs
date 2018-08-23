## Using CoreData in Contacts App

This week for lab, we will be revisiting the ContactsLite application from lecture and changing the implementation of saving/loading state to run off of CoreData. CoreData is a means of interfacing with internal iOS device data that mimics the use of a SQLite database.

In general, using CoreData to manage state is much preferred to plists, due to the allowance of relational entities and condensed code. You can learn more about CoreData [through the official Apple documentation](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/index.html).

<p float="left" align="center">
  <img src="https://i.imgur.com/pXkwNSy.png" width="32%" />
  <img src="https://i.imgur.com/PAcnVRB.png" width="32%" /> 
  <img src="https://i.imgur.com/sOOGYOQ.png" width="32%" /> 
</p>

### Part 0: Familiarizing with ContactsLite
First, we are going to take a look at the previous ContactsLite application to remember how we handled the saving/loading of data with plists, and how to interact with a `TableView`. **Please start by cloning the ContactsLite Application [here](https://github.com/profh/67442_ContactsLite)**.

Take some time to go through the application and refresh yourself on some specific details, including:

* The overall user interface.
* The `TableViewCell` class.
* Saving contact data
* Loading contact data

### Part 1: Starting the ContactsAdvanced Application

Now, we will be setting up a new Xcode Single View App called "ContactsAdvanced". **Be sure to check the "Use CoreData" option** upon setup since this will create the necessary files for interfacing with CoreData.

Once the application is created, let's visit the following files to take notice of what was created for us upon checking the "Use CoreData" option upon setup.

#### Investigating App Delegate

Go into the `AppDelegate.swift` file and we will notice a new module being imported: `CoreData` on line 10. If we now scroll down to line 49, we will see the creation of our `Persistent Container`, which we will refer to in order to allow us to interface with `CoreData`. Furthermore, on line 78, we have a new `saveContext()` function which we will also refer to in helping save data via `CoreData`.

#### Investigating ContactsAdvanced.xcdatamodeld

Selecting the "Use CoreData" option also invoked the creation of a new file in our project: `ContactsAdvanced.xcdatamodeld`. Click on this file to see the UI for managing entities with CoreData. We will come back to this file in a little bit to set up our Contact entity.

#### Creating the UI

Now let's recreate the UI from the ContactsLite Application. You should be able to see how to construct a TableView from ContactsLite, so go ahead and construct this TableView, as well as the generic detail pages after drilling down on a specific TableView cell.

Feel free to re-design the detail pages to your liking, but they should have the following information for a user (represented in a Contact class):

* Name
* Email
* Work Phone
* Home Phone
* Contact Photo (using an ImageView object)

Of course, use Auto Layout to style the UI for multiple devices.

#### Completing the Table View

For the TableView, we are requiring you to use a xib so that each table view cell is better formatted. How exactly you choose to format is up to you, but it must be a xib. For this xib, be sure to register it properly (in the `viewDidLoad` method in your TableViewController). One idea could be to have the user's photo show up next to their name.

I would recommend pulling most of the TableView functions from ContactsLite, but note the UI elements must be connected to the appropriate controllers.

#### Using Images

For this lab, we are going to update our initial contacts application by allowing the use of images for our contacts. There are a couple of steps that need to be taken to properly use the images from the Camera Roll on an iOS device.

**Note that every file which uses the following commands must have an `import Photos` at the top of the file**

##### Authorization

The first thing we must do in order to get access to a user's photo library is request authorization. Doing so is pretty simple:

* In `Info.plist` add a new key into Information Property List of "Privacy - Photo Library Usage Description", with a value of "To add photos for contacts."
* In your AddContactController (or whatever controller manages where photos are being pulled in the Add Contact form), add `PHPhotoLibrary.requestAuthorization({_ in return})` to `viewDidLoad()`.

Now, the first time when users load this page in the app, they will see a popup asking for permission to use the photo library on the device.

##### ImagePicker and Previewing Images

The ImagePicker is the iOS control for selecting a picture from the photos library on the device. Luckily, we just have to implement the required interface to get access to whichever photo is being selected by the user.

* Add the `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate` inheritences to the definition of the AddContactController class.
* Add two new attributes within this AddContactController class: `let imagePicker = UIImagePickerController()` and `var picture: UIImage?`.
* Add a UIImageView outlet named picPreview and wire it up appropriately.
* We need to tell the imagePicker that this class is its delegate, add `imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)` to the end of the `viewDidLoad` function.
* Add these two functions to the end of the class: 
    ```swift
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
    ```
    The first function is to be connected to an "Add Photo" button in the UI to open up the imagePicker on the phone. Here we designate we don't want any photo editing and we want to select a photo from the photo library.

    The second function is a callback for after the image has been selected. It assigns the selected image to the class attribute `picture` and updates the image view element on the form to show the chosen image.
* Be sure to save the picture as part of the contact object as well when the contact has been created successfully (in the `done` function).
* Using what we have done to update the preview, create a similar UIImageView element on the detail page and have it show the chosen picture for the contact.

**At this point, verify you can create a new contact with images in both the Add Contact form and Detail View.**

### Part 2: Adding Core Data
Here, after the main UI functionality has been built, we will walk students through the process of setting up entities in CoreData, saving data, and loading data.

##### Creating an Entity

Xcode conveniently sets up a GUI by which we can work with to set up entities for our application. This is located in the ContactsAdvanced.xcdatamodeld file.

Create a new entity named "People" with five attributes:

* email (String)
* home_phone (String)
* name (String)
* work_phone (String)
* picture (Binary Data) *Note photo must be stored as raw data*

Here is a picture of what your entity should look like, with the "Add Entity" button highlighted for you as well:

<p align="center">
  <img src="https://i.imgur.com/k1MLR6X.png" width="70%">
</p>

##### Saving Contacts

First `import CoreData` in the AddContactController.swift file.

We will create a new function in the AddContactsController named `saveContact(contact: Contact)` which will manage adding our contact to the CoreData entity. This function is as follows:

```swift
  func saveContact(contact: Contact){
    // Connect to the context for the container stack
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    // Specifically select the People entity to save this object to
    let entity = NSEntityDescription.entity(forEntityName: "People", in: context)
    let newUser = NSManagedObject(entity: entity!, insertInto: context)
    // Set values one at a time and save
    newUser.setValue(contact.email, forKey: "email")
    newUser.setValue(contact.name, forKey: "name")
    newUser.setValue(contact.homePhone, forKey: "home_phone")
    newUser.setValue(contact.workPhone, forKey: "work_phone")
    // Safely unwrap the picture
    if let pic = contact.picture {
      newUser.setValue(UIImagePNGRepresentation(pic), forKey: "picture")
    }
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
  }
```
Note that we have to get the PNG version of the provided image to save in as Binary Data. Now just call this function in `done` right before the delegate call to `addContactController`.

##### Loading Contacts

Lastly, we just need to populate the TableView with contacts from CoreData. Let's do this in the `viewDidLoad` function in the initial ViewController after registering your table cell xib.

```swift
// Again set up the stack to interface with CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let request = NSFetchRequest<NSFetchRequestResult>(entityName: "People")
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
```

Now we just need to add the `loadContacts` function in this class:

```swift
func loadContacts(data: NSManagedObject){
  let newContact = Contact()
  newContact.name = data.value(forKey: "name") as! String
  newContact.email = (data.value(forKey: "email") as! String)
  newContact.homePhone = (data.value(forKey: "home_phone") as! String)
  newContact.workPhone = (data.value(forKey: "work_phone") as! String)
  newContact.picture = UIImage(data:(data.value(forKey: "photo") as! NSData) as Data, scale:1.0)
  contacts.append(newContact)
}
```

Now our contacts should be saving to and loading from CoreData! Try running the application multiple times to see this is the case :)

##### Deleting Contacts

Of course, sometimes friendships take a turn for the worst and we need to delete contacts from our device. After recovering from heartbreak we see that in our app right now it looks like we may be able to delete contacts from the list of all contacts by going to Edit > deleting one (if we are using the UI from ContactsLite!), but when we restart the app they are still there, causing more heartbreak. We need to put an end to this, but also give our application the ability to remove contacts from Core Data.

Fortunately, there is already a spot in our code to add this logic in. It is in the ViewController file in the function `tableView(_:commit:editingStyle:forRowAt)`. Find this function, and replace the first conditional clause (for deletion), with the following:

```swift
if editingStyle == .delete {
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let context = appDelegate.persistentContainer.viewContext
  let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
  request.returnsObjectsAsFaults = false
  do {
    let result = try context.fetch(request)
    for data in result as! [NSManagedObject] {
      // if the contact we are deleting is the same as this one in CoreData {
        context.delete(data)
        try context.save()
      }
    }
  } catch {
    print("Failed")
  }
  contacts.remove(at: indexPath.row)
  tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
}
```

All that remains here is for us to figure out how to delete the exact contact the user has requested from CoreData. Take a look at the logic and determine how to compare the CoreData entity with our object in `self.contacts`, then replace the commented out `if` statement above! Then our heartbreak will be eased, and the app completed.

Qa'pla!
