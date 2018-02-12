import Foundation

class RepositoriesViewModel {
  var repos = [Repository]()
  
  let client = SearchRepositoriesClient()
  let parser = RepositoriesParser()
  
  func numberOfRows() -> Int {    
    // Your code here
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    // Your code here
  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> RepositoryDetailViewModel {
    // Your code here
  }
}
