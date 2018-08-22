# Implementing Observables and Subjects using Combinestagram
*Note this lab is based off of chapter four of Ray Wenderlich's Book "RxSwift: Reactive Programming with Swift"*

## Combinestagram
In this lab, we will be creating an application called "Combinestagram" which allows the user to create quick collages of their own pictures on their iOS device. We will be building off of the photo library usage content from the "ContactsAdvanced" lab as well to allow users to select photos. Of course, we will be wrapping the UI elements in the RxSwift framework using Observables and Subjects, before later being sure to remove unused resources properly in the back. Here is a demo of the final app:

<p align="center">
  <img src="https://i.imgur.com/Cto7Y8A.png" width="40%">
</p>

## Part 1: Building the Initial ViewController
1. You can find the starter code for the lab [here](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%20Combinestagram/RxCombinestagram%20-%20starter). Clone it and perform a `pod install` from within this directory. Because we are using CocoaPods for this project, we should be sure to open the `Combinestagram.xcworkspace` file from within the project directory.

2. The basic UI has been constructed for us in `Main.storyboard` (including wiring up variables), so take a quick look at it. Note the + in the top-right corner will eventually open a new ViewController for the user to select a new image for their collage, the "clear" button will erase the existing collage, and the "save" button will save the collage to the user's photo library. The collage implementation has also been completed for us, in `UIImage+Collage.swift`

3. Now we will begin to modify the `MainViewController`, so open it.

    Add the following code inside the `MainviewController`:

    ```swift
    private let bag = DisposeBag()
    private let images = Variable<[UIImage]>([])
    ```

    Note the `bag` variable we created won't actually help clean up the `MainViewController` as it is the root, but we will fix this later.

4. Note that the `actionAdd()` method in the `MainViewController` is tied to the button to add a new image. For now, let's experiment with adding a `UIImage` (which should serve as a throwback to the ContactsAdvanced lab) by adding this line inside of the `actionAdd()` method:

    ```swift
    images.value.append(UIImage(named: "IMG_1907.jpg")!)
    ```

    Similarly, let's update the `actionClear()` method to clear our array of images:

    ```swift
    images.value = []
    ```

    Now, if we run the application, we will simply add the same stock image (great for testing), but let's not actually run the app yet because we need to connect images to the UI through being an Observable.

5. Now it is time for us to create a subscription to our `images` array. We should do this in our `viewDidLoad()` method so it is created right when the ViewController is instantiated:

    ```swift
    images.asObservable()
    .subscribe(onNext: { [weak self] photos in
      guard let preview = self?.imagePreview else { return }
      // Set the preview image to be what is selected
      // if something is selected
      preview.image = UIImage.collage(images: photos,
        size: preview.frame.size)
    })
    .disposed(by: bag)
    ```

    Here we create a subscription which when something is changed in the `images` array results in the creation of a new collage, and declare the appropriate disposal bag.

    Now, we should be able to run our application, and add the same stock image multiple times using the + button in the top-right corner. We can also clear the image with the clear button as well (since our subscription works for clearing the `images` array).

6. Note that we can dynamically update our UI through the `onNext` clause of the subscription (perhaps through a helper function called `updateUI`). We can also just add a new subscription inside of our `viewDidLoad()`:

    ```swift
    images.asObservable()
      .subscribe(onNext: { [weak self] photos in
          self?.updateUI(photos: photos)
      })
      .disposed(by: bag)
    ```

    and a new helper method inside of our `MainViewController` to update the UI based on the number of photos provided:

    ```swift
    private func updateUI(photos: [UIImage]) {
      buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
      buttonClear.isEnabled = photos.count > 0
      itemAdd.isEnabled = photos.count < 6
      title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }
    ```

    Now you can run the application to see a dynamically updating UI as well surrounding the collage.

## Part 2: Using Subjects for View Controller Communication
Now, we are going to tackle the problem of adding in new user photos a bit differently from how we will access the photos library in the next lab. We already have a basic `PhotosViewController` constructed, but now we have to work to have it interact with the `MainViewController`.

1. First, we will need to add this new View Controller to the UI when the user wishes to add a new photo to the collage. Let's go into the `MainViewController` and replace the code that adds the same stock image ("IMG_1907.jpg") with the following:

    ```swift
    let photosViewController = storyboard!.instantiateViewController(
        withIdentifier: "PhotosViewController") as! PhotosViewController
    navigationController!.pushViewController(photosViewController, animated:
      true)
    ```

    Because this has been built for you, you can go ahead and run the app and try to add a new photo to see what the base `PhotosViewController` looks like. Note the first tie you try to add a new photo you will need to give the app permission to do so.

2. Now we need to keep track of the photos a user selects from their camera roll. Let's start this by opening the `PhotosViewController.swift` file and adding `import RxSwift` near the top.

3. In the `PhotosViewController` let's add two new properties to the class:

    ```swift
    private let selectedPhotosSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
      return selectedPhotosSubject.asObservable()
    }
    ```

    Also in the class, there is an implemented procotol function `collectionView(_:didSelectItemAt:)`. In here, there is a closure which uses the Rx framework in `imageManager.requestImage()` using `.next`. Just after the guard statement here, add the following code:

    ```swift
    if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as?
    Bool, !isThumbnail {
      self?.selectedPhotosSubject.onNext(image)
    }
    ```

4. Now that we have set up the observable of chosen photos, we need to actually subscribe to it in our `MainViewController`. Switch to `MainViewController.swift`. We can subscribe to our selected photos in the `actionAdd()` method right before pushing the `PhotosViewController`:

    ```swift
    photosViewController.selectedPhotos
      .subscribe(onNext: { [weak self] newImage in
        guard let images = self?.images else { return }
        images.value.append(newImage)
      }, onDisposed: {
        print("completed photo selection")
      })
      .disposed(by: bag)
    ```

    Now, go ahead and run the app to see you can select images from the photos library to populate the collage!

    One important thing to note, we actually never can dispose of this subscription, which causes an unwanted memory leak! What we can do is trigger a completion for the subscription from the `PhotosViewController`.

5. Switch back to `PhotosViewController.swift` and add the following line to `viewWillDisappear`:

    ```swift
    selectedPhotosSubject.onCompleted()
    ```

## Part 3: Custom Observables
Now, we have everything we need for RxCombinestagram to work properly, except for saving the collage to the user's photo library. The `PHPhotoLibrary` API allows us to save information to the user's photo library.

1. Open the `PhotoWriter.swift` file and `import RxSwift` towards the top.

2. We need to add a new static method to this class which creates our observable to save photos. Add the following code to the class:

    ```swift
    static func save(_ image: UIImage) -> Observable<String> {
      return Observable.create({ observer in
        // Callback when creating a new observable
        var savedAssetId: String?
        PHPhotoLibrary.shared().performChanges({
          //  Place to create a photo
        }, completionHandler: { success, error in
          // Place which will emit an error or the asset ID
        })
      }) 
    }
    ```

3. Inside the place to create a photo within the first argument to `performChanges`, let's add the following code:

    ```swift
    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
    savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
    ```

    Here, we are creating a new photo object and hanging onto its `id`. Once this is complete, we want to pass this `id` to subscribers of this observable and complete the data stream, otherwise we want to pass an error. Add this code into the `completionHandler` block:

    ```swift
    DispatchQueue.main.async {
      if success, let id = savedAssetId {
        observer.onNext(id)
        observer.onCompleted()
      } else {
        observer.onError(error ?? Errors.couldNotSavePhoto)
      }
    }
    ```

4. Lastly, we need to add `return Disposables.create()` to the end of `Observable.create({...})`.

5. Now, we simply need to actually subscribe to this observable to allow saving to the photos library. We can do this by going back to `MainViewController.swift` and adding the following code in the `actionSave()` method tied to the save button:

    ```swift
    guard let image = imagePreview.image else { return }
    PhotoWriter.save(image)
      .asSingle()
      .subscribe(onSuccess: { [weak self] id in
        self?.showMessage("Saved with id: \(id)")
        self?.actionClear()
      }, onError: { [weak self] error in
        self?.showMessage("Error", description: error.localizedDescription)
      })
      .disposed(by: bag)
    ```

    Now, you should be able to save your collage to the photos library!

Note how we were able to update our images in the collage dynamically using the RxSwift framework. This helps us reduce code to change our UI and can come quite in handy for the upcoming project!
