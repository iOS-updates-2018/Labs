import Foundation

class RepositoriesViewModel {
  var repos = [Repository]()
  var filteredRepos = [Repository]()
  
  let client = SearchRepositoriesClient()
  let parser = RepositoriesParser()
  
  func refresh(_ completion: @escaping () -> Void) {
    client.fetchRepositories { [unowned self] data in
      if let repositories = self.parser.repositoriesFromSearchResponse(data) {
        self.repos = repositories
      }
      completion()
    }
  }
  
  func numberOfRows() -> Int {    
    if filteredRepos.isEmpty {
      return repos.count
    } else {
      return filteredRepos.count
    }
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < repos.count else {
        return ""
    }
    if filteredRepos.isEmpty {
      return repos[indexPath.row].name
    } else {
      return filteredRepos[indexPath.row].name
    }
  }
  
  func summaryForRowAtIndexPath(_ indexPath: IndexPath) -> String {
    guard indexPath.row >= 0 && indexPath.row < repos.count else {
      return ""
    }
    if filteredRepos.isEmpty {
      return repos[indexPath.row].description
    } else {
      return filteredRepos[indexPath.row].description
    }
  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> RepositoryDetailViewModel {
    let repo = (filteredRepos.isEmpty ? repos[indexPath.row] : filteredRepos[indexPath.row])
    return RepositoryDetailViewModel(repository: repo)
  }
  
  func updateFiltering(_ searchText: String) -> Void {
    filteredRepos = self.repos.filter { repo in
      return repo.name.lowercased().contains(searchText.lowercased())
    }
  }
  
}
