import UIKit

class GFItemInfoViewController: UIViewController {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemInfoViewOne = GFItemInfoView()
    let itemInfoViewTwo = GFItemInfoView()
    let actionButton = GFButton(frame: .zero)
    
    var user: User!
    weak var delegate: UserInfoViewControllerDelegate! //Architecture: delegates allways need to be weak to avoid retain cycles
    
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
        configureActionButton()
    }
    
    private func setUpViews() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
        view.addSubview(stackView)
        view.addSubview(actionButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {}
}

extension GFItemInfoViewController {
    enum Constants {
        static let padding: CGFloat = 20
    }
}
