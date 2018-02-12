import UIKit

// MARK: UISearch extension
extension RepositoriesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

// MARK:- Repo View Controller
class RepositoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: Properties & Outlets
  let viewModel = RepositoriesViewModel()
  let searchController = UISearchController(searchResultsController: nil)

  @IBOutlet var tableView: UITableView!
  
  
  // MARK: Std View Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // register the nib
    let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: "cell")
    // set up the search bar (method below)
    setupSearchBar()
    // get the data for the table
    viewModel.refresh { [unowned self] in
      DispatchQueue.main.async {
          self.tableView.reloadData()
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: true)
    }
  }
  
  
  // MARK: Table View
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.name?.text = viewModel.titleForRowAtIndexPath(indexPath)
    cell.summary?.text = viewModel.summaryForRowAtIndexPath(indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "toDetailVC", sender: indexPath)
  }
  
  // MARK: Segues  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? RepositoryDetailViewController,
      let indexPath = sender as? IndexPath {
      detailVC.viewModel = viewModel.detailViewModelForRowAtIndexPath(indexPath)
    }
  }
  
  
  // MARK: Search Methods
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    tableView.tableHeaderView = searchController.searchBar
    searchController.searchBar.barTintColor = UIColor(red:0.98, green:0.48, blue:0.24, alpha:1.0)
  }
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    viewModel.updateFiltering(searchText)
    tableView.reloadData()
  }

}


