
import UIKit

// Architecture: why use a childViewController insted of just a UIView?
//      - we get access to all lyfecycle methods (viewdidload, viewWillappear...)
//      - viewController can be pushed on a navigationController etc
class GFUserInfoHeaderViewController: UIViewController {
    
    lazy var avatarImageView: GFAvatarImageView = {
        let imageView = GFAvatarImageView(frame: .zero)
        imageView.configure(with: user.avatarUrl)
        return imageView
    }()
    
    lazy var usernameLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .left, fontSize: 34)
        label.text = user.login
        return label
    }()

    lazy var nameLabel: GFSecondaryTitleLabel = {
        let label = GFSecondaryTitleLabel(fontSize: 18)
        label.text = user.name ?? ""
        return label
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: SFSymbols.location)
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    lazy var locationLabel: GFSecondaryTitleLabel = {
        let label = GFSecondaryTitleLabel(fontSize: 18)
        label.text = user.location ?? "No Location"
        return label
    }()
    
    lazy var bioLabel: GFBodyLabel = {
        let label = GFBodyLabel(textAlignment: .left)
        label.numberOfLines = Constants.bioNumberOfLines
        label.text = user.bio ?? "No bio available"
        return label
    }()
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            bioLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension GFUserInfoHeaderViewController {
    private enum Constants {
        static let padding: CGFloat = 20
        static let textImagePadding: CGFloat = 12
        static let bioNumberOfLines: Int = 3
    }
}
