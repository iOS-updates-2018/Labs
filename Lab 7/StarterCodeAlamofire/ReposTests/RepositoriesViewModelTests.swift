import XCTest
@testable import Repos

class RepositoriesViewModelTests: XCTestCase {

    func test_numberOfRows() {
        let repos = [createRepository(), createRepository(), createRepository()]
        let viewModel = RepositoriesViewModel()
        viewModel.repos = repos
        
        XCTAssertEqual(viewModel.numberOfRows(), 3)
    }
    
    func test_titleForRowAtIndexPath() {
        let repo1 = Repository(id: 0, name: "Alamofire", description: "", htmlURL: nil)
        let repo2 = Repository(id: 1, name: "SwiftyJSON", description: "", htmlURL: nil)
        let repos = [repo1, repo2]
        let viewModel = RepositoriesViewModel()
        viewModel.repos = repos
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath1), "Alamofire")
        
        let indexPath2 = IndexPath(row: 1, section: 0)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath2), "SwiftyJSON")
        
        let indexPath3 = IndexPath(row: 99, section: 99)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath3), "")
    }
    
    func test_detailViewModelForRowAtIndexPath() {
        let repo1 = Repository(id: 0, name: "foo", description: "desc", htmlURL: nil)
        let repo2 = Repository(id: 1, name: "bar", description: "desc", htmlURL: nil)
        let repos = [repo1, repo2]
        
        let viewModel = RepositoriesViewModel()
        viewModel.repos = repos
        
        let indexPath = IndexPath(row: 1, section: 0)
        let detailVM = viewModel.detailViewModelForRowAtIndexPath(indexPath)
        XCTAssertEqual(detailVM.repository.id, repo2.id)
    }
    
    func createRepository() -> Repository {
        return Repository(id: 0, name: "foo", description: "bar", htmlURL: nil)
    }
}
