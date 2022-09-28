import UIKit
import Combine
import Networking

final class PhotoListViewController: UITableViewController {
    private var refreshController: PhotoFeedRefreshViewController?
    private let searchController = UISearchController(searchResultsController: nil)
    lazy private var dataSource = makeDiffableDataSource()
    var cancellables = Set<AnyCancellable>()
    var onSearch: ((String) -> Void)?
    var onBottomScroll: (() -> Void)?
    var debouncer = Debouncer(timeInterval: 0.5)
    var tableModel = [PhotoCellController]()
    
    convenience init(refreshController: PhotoFeedRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func makeDiffableDataSource() -> UITableViewDiffableDataSource<Int, PhotoCellController> {
        .init(tableView: tableView) { tableView, _, cellController in
            return cellController.view(tableView: tableView)
        }
    }
    
    func display(cellControllers: [PhotoCellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoCellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers)
        dataSource.apply(snapshot)
    }
    
    func update(cellControllers: [PhotoCellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PhotoCellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        tableModel[indexPath.row].cancelLoad()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PhotoCellController {
        return tableModel[indexPath.row]
    }
    
    //  MARK: - UI Set up
    
    private func setupUI() {
        setUpSearchController()
        setUpTableView()
        setUpRefreshControl()
    }
    
    private func setUpRefreshControl() {
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    private func setUpTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        tableView.dataSource = dataSource
    }
    
    private func setUpSearchController() {
        searchController.searchBar.placeholder = "Search photos"
        searchController.obscuresBackgroundDuringPresentation = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        
        let publisher = NotificationCenter.publisherFor(searchController: searchController)
        
        publisher.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] in self?.manageSearch($0) }
            .store(in: &cancellables)
    }
    
    private func manageSearch(_ text: String) {
        onSearch?(text)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = cellController(forRowAt: indexPath)
        controller.loadFullSize()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        super.scrollViewDidScroll(scrollView)
        
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if distanceFromBottom < height + 500 {
            debouncer.handler = { [weak self] in
                self?.onBottomScroll?()
            }
            
            debouncer.renewInterval()
        }
    }
}
