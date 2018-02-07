import UIKit

class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView?
    
    var viewModel: RepositoryDetailViewModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = viewModel?.title()

        if let viewModel = viewModel,
            let urlString = viewModel.URLString(),
            let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView?.loadRequest(request)
        }
    }
}
