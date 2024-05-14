import UIKit

class GFEmptyStateView: UIView {
    
    let message: String
    
    lazy var messageLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 28)
        label.text = message
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_state_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(message: String) {
        self.message = message
        super.init(frame: .zero)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubview(logoImageView)
        addSubview(messageLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 200),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 140)
        ])
    }
}
