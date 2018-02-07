import XCTest
@testable import Repos

class RepositoryDetailViewModelTests: XCTestCase {
    func test_title() {
        let repo = Repository(id: 0, name: "foo", description: "bar", htmlURL: nil)
        let viewModel = RepositoryDetailViewModel(repository: repo)
        XCTAssertEqual("foo", viewModel.title())
    }
    
    func test_URLString() {
        let repo = Repository(id: 0, name: "foo", description: "bar", htmlURL: "https://github.com/ipader/SwiftGuide")
        let viewModel = RepositoryDetailViewModel(repository: repo)
        XCTAssertEqual("https://github.com/ipader/SwiftGuide", viewModel.URLString())
    }
}
