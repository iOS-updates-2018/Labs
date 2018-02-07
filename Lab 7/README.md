OBJECTIVES
===
- help students practice TDD in Swift
- teach students how to build and use View Models
- give students experience with table views
- reinforce skills related to API handling and JSON


CONTENTS
===
1. In this lab we will be building an application to look at the most popular Swift repositories on Github using the Github API and many of the skills we have learned in class. You are allowed and encouraged to use [Alamofire](https://alamofire.github.io/Alamofire/) and [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to make it easier to write this lab and to producer cleaner code.

1. Download the [starter files here](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%207). This is an Xcode project with a testing suite and other key features in place.  Unzip and open this project in Xcode.

Part 1: Building out models with TDD
---
1. You've been given a repository model cleverly called `Repository`, which is just a simple struct.  In this case since it has no methods, there is no compelling reason to test it.  You also need a network handler class (SearchRepositoriesClient); automated testing for this is tricky and so for now I've simply given this class to you.

1. Let's focus our attention first on the parser class (RepositoriesParser). The first method `parseDictionary` simply uses `JSONSerialization` to parse the json and prints a simple error message if the json can't be parsed.  The second method `repositoriesFromSearchResponse` uses the first method to parse the JSON (if possible; handle errors otherwise) and put the "items" into a variable `repoDicts = dict["items"]`. Then we loop over the `repoDicts` and convert them to an array of `Repository` objects.  The `flatMap` method could be really useful here, but we also need a method that during this process will take each element in `repoDicts` and parse it so that we have a `Repository` object -- that's where the last method comes in. The `parseRepository` takes an element from `repoDicts` and pulls out `id`,`name`,`description`, and `html_url` and puts it in a new `Repository` object. (If this explanation is unclear, see the TAs for clarification.) Build out your model and run the tests to see the ones for the parser pass.

1. Next let's look at the easier of the two view models, `RepositoryDetailViewModel`. Looking at the details only makes sense in the context of a specific repository, so create a repository property of type Repository. (It's not optional because we'd never have a `RepositoryDetailViewModel` without a specific repository attached to it.) After that, create a basic `init` method that sets that property to whatever repository object was passed along at init. (Again, `init` must take a specific repository as an argument.) Once that's set, there are only two very simple methods that get implemented here and we have tests for both.  Write this model and make sure it passes all its tests.

1. Finally, let's look at the view model `RepositoriesViewModel` which is associated with the `RepositoriesViewController`. (This is our initial view controller that displays the repos in a table view.) There are three methods for us to build out and make sure our tests pass.

Part 2: Building out the view controller
---
1. Because I'm uncertain about the time this lab will take, I've given you a completed storyboard that's been wired up and the simple view controller, `RepositoryDetailViewController`. If you have time, feel free now or later to delete these items and build them from scratch. FYI, in the storyboard I did not use a table view controller, but rather did it the 'old school' way with a regular view controller and added a table view and a table view cell to it, but it could be done either way.  If you are redoing `RepositoryDetailViewController` from scratch, looking at the [SimpleBrowser lab](http://67442.cmuis.net/labs/3) would be helpful as this is pretty much just a webview of the repo on [github.com](https://github.com) much like the webview we did in SimpleBrowser.

1. We will start with `RepositoriesViewController` by adding in the protocols `UITableViewDataSource` and `UITableViewDelegate` to the class declaration at the top (left a little space there, but you will need more). After adding them in, hover over each with the option key pressed to get the question_mark cursor and click to see more details about each of these protocols.

1. Because we are working with the table view delegate, there are two related methods we will want to implement.  The first `numberOfRowsInSection` is pretty easy: we go to our view model and ask it how many rows there are. The second table view method `cellForRowAtIndexPath` asks the data source for a cell to insert in a particular location of the table view. We can start this method with the following:

  ```swift
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.name?.text = viewModel.titleForRowAtIndexPath(indexPath)
    cell.summary?.text = viewModel.summaryForRowAtIndexPath(indexPath)
    return cell
  ```

  Finally we need to prepare for the segue. We've done this before and can do something pretty similar here with the following:

  ```swift
    if let detailVC = segue.destination as? RepositoryDetailViewController,
      let indexPath = sender as? IndexPath {
      detailVC.viewModel = viewModel.detailViewModelForRowAtIndexPath(indexPath)
    }
  ```

  Be sure to use the question_mark cursor (option key) to investigate any table view methods you don't understand and want to explore further.

1. If I build this project right now, it all works in a technical sense, but there are no repos being displayed. The problem is that whenever `viewDidLoad` happens (initially or when I return from a detail view) I need to refresh the list of repos. Since this involves a network call, I'd like to do it asynchronously. In theory the view model would have a `refresh` method that would make the network call and parse the data so I could then use the table view's `reloadData` call to populate my cells. Assuming I had such a method, I could simply add the code below to `viewDidLoad`:

  ```swift
  viewModel.refresh { [unowned self] in 
    dispatch_async(dispatch_get_main_queue()) {
      self.tableView.reloadData()
    }
  }
  ```

1. Of course, now I need to go back to the view model and create this `refresh` method. We could do with the following code to get us started:

  ```swift
  func refresh(completion: () -> Void) {
    client.fetchRepositories { [unowned self] data in
      
      // we need in this block a way for the parser to get an array of repository
      // objects (if they exist) and then set the repos var in the veiw model to 
      // those repository objects

      completion()
    }
  }
  ```

  Now build the project and see that in fact it is able to get the repos and populate the table view.

---
If time allows, you can go back and remove the storyboard objects and rewire it yourself or redo the details view controller from scratch as mentioned earlier. You can also explore customizing the table cell more by perhaps adding in the description (which is in our `Repository` model but is unused and feeling a little neglected right now) in smaller type below the repo name.  Feel free to explore further -- that's where the real fun and learning is! 

Qapla'