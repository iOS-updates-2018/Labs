import Foundation

class RepositoryDetailViewModel {
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func title() -> String {
        return repository.name
    }
    
    func URLString() -> String? {
        return repository.htmlURL
    }
}