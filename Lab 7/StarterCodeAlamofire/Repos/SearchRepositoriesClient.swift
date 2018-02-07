import Foundation
import Alamofire

class SearchRepositoriesClient {
  func fetchRepositories(_ completion: @escaping (Data?) -> Void) {
    
    let urlString = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"
      
    Alamofire.request(urlString).response { response in
      if let error = response.error {
        print("Error fetching repositories: \(error)")
        completion(response.data)
        return
      }
      completion(response.data)
    }
    
  }
}
