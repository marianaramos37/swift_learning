import UIKit

class GFAlertViewController: UIViewController {

    // Personal opinion: since this custom GF components don't have many configuration we could do it here when creating the components.
    // Arquitecture: I define everything when defining the variables so I don't have to run the code looking for this kind of specifications
    
    let containerView: UIView = {
        let containterView = UIView()
        containterView.backgroundColor = .systemBackground
        containterView.layer.cornerRadius = 16
        containterView.layer.borderWidth = 2
        containterView.layer.borderColor = UIColor.white.cgColor
        containterView.translatesAutoresizingMaskIntoConstraints = false
        return containterView
    }()
    
    lazy var titleLabel: GFTitleLabel = {
        let title = GFTitleLabel(textAlignment: .center, fontSize: 20)
        title.text = alertTitle ?? "Something went wrong"
        return title
    }()
    
    lazy var messageLabel: GFBodyLabel = {
        let label = GFBodyLabel(textAlignment: .center)
        label.text = message ?? "Unable to complete request"
        label.numberOfLines = 4
        return label
    }()
    
    lazy var actionButton: GFButton = {
        let button = GFButton(backgroundColor: .systemPink, title: "Ok")
        button.setTitle(buttonTitle ?? "Ok", for: .normal)
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        return button
    }()
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, buttonTitle: String) { // TODO: colocar isto num VM e o padding etc num theme
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75) // black with oppacity
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(actionButton)
        containerView.addSubview(messageLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            //Container view
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            //Title label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            //Action button
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            //Message label
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    @objc
    private func dismissViewController() {
        dismiss(animated: true)
    }
}
