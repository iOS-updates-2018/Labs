import Foundation

typealias JSONDictionary = [String: AnyObject]

class RepositoriesParser {
    func parseDictionary(_ data: Data?) -> JSONDictionary? {
        // Your code here
    }
    
    func repositoriesFromSearchResponse(_ data: Data?) -> [Repository]? {
        // Your code here
    }
    
    func parseRepository(_ dict: JSONDictionary) -> Repository? {
        // Your code here
    }
}
