import UIKit

protocol FollowerListViewControllerDelegate: AnyObject { // Architecture: The use of AnyObject
    func didRequestFollowers(for username: String)
}

class FollowerListViewController: UIViewController {
    
    enum Section { //Enums are hashable by default
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var hasMoreFollowers: Bool = true
    var page: Int = 1
    
    lazy var dataSource: UICollectionViewDiffableDataSource<Section, Follower> = {
        // DiffableDataSource parameters both has to conform to hashable
        let dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FollowerCollectionViewCell.reuseID,
                    for: indexPath
                ) as! FollowerCollectionViewCell
                cell.configure(follower: follower)
                return cell
            }
        )
        return dataSource
    }()
    
    lazy var collectionView: UICollectionView = {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: flowLayout
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCollectionViewCell.self, forCellWithReuseIdentifier: FollowerCollectionViewCell.reuseID)
        collectionView.delegate = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        setUpViews()
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        // If we don't do this the navbar will be hidden because it was hidden in the previous view controller
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        // This makes the page title bigger and bellow the back button.
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers)
                // Network manager has a strong reference to our FollowerListViewController.
                // So we have to make it weak above.
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them."
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                    }
                    return
                }
                self.updateData(on: self.followers)
            case .failure(let gfError):
                self.presentGFAlertOnMainThread(
                    title: "Bad Stuff Happened",
                    message: gfError.rawValue,
                    buttonTitle: "Ok"
                )
            }
        }
    }
    
    private func setUpViews() {
        view.addSubview(collectionView)
    }
}

// MARK: - Data Source
extension FollowerListViewController {
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { // Calling apply from the main thread
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICOllectionViewDelegate
extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let follower = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let userInfoViewController = UserInfoViewController()
        userInfoViewController.username = follower.login
        userInfoViewController.delegate = self // Architecture: the followerListViewController is now listening to the userInfoViewController. When the userInfoVC needs to update the followers, the FollowerListVC will do so.
        
        let navController = UINavigationController(rootViewController: userInfoViewController)
            // This navController is so that we have a button to dismiss the userInfoViewController (that is a modal). So that we conform with the accessibility guidelines
        present(navController, animated: true)
    }
    
    @objc func addButtonTapped() {
        
    }
}

// MARK: - Search
extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard 
            let filter = searchController.searchBar.text,
            !filter.isEmpty
        else {
            return
        }
        filteredFollowers = followers.filter{
            $0.login.lowercased().contains(filter.lowercased())
        }
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateData(on: followers)
    }
}

extension FollowerListViewController: FollowerListViewControllerDelegate {
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
