import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {

    var username: String!
    weak var delegate: FollowerListViewControllerDelegate!
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpViews()
        setUpConstraints()
        getUserInfo()
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissViewController)
        )
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setUpViews() {
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        view.addSubview(dateLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: Constants.padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: Constants.itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: Constants.padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(
                    title: "Something went wrong",
                    message: error.rawValue,
                    buttonTitle: "Ok"
                )
            }
        }
    }
    
    private func configureUIElements(with user: User) {
        let repoItemViewController = GFRepoItemViewController(user: user)
        repoItemViewController.delegate = self
        
        let followerItemViewController = GFFollowerItemViewController(user: user)
        followerItemViewController.delegate = self
        
        self.add(
            childViewController: GFUserInfoHeaderViewController(user: user),
            to: self.headerView
        )
        self.add(
            childViewController: repoItemViewController,
            to: self.itemViewOne
        )
        self.add(
            childViewController: followerItemViewController,
            to: self.itemViewTwo
        )
        self.dateLabel.text = "GitHub Since \(user.createdAt.convertToDisplayFormat())"
    }
    
    private func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}

extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "Ok")
            return
        }
        presentSafariViewController(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers.", buttonTitle: "Ok")
            return
        }
        
        delegate.didRequestFollowers(for: user.login)
        dismissViewController()
    }
}

extension UserInfoViewController {
    enum Constants {
        static let padding: CGFloat = 20
        static let itemHeight: CGFloat = 140
    }
}
