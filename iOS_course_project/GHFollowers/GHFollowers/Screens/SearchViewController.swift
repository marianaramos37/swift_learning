import UIKit

class SearchViewController: UIViewController {

    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.image = UIImage(named: "gh_logo") // Architecture: This is a stringly type, prone to errors. We should put it into a constant
        return logo
    }()
    
    private let usernameTextField = GFTextField()
    
    private let callToActionButton = GFButton(
        backgroundColor: .systemGreen,
        title: "Get Followers"
    )
    
    var isUsernameEntered: Bool {
        return !usernameTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // for white mode is black, for dark mode is white
        setUpViews()
        setUpConstraints()
        setUpActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
            // We call this here because we want the navigaiton bar to hide every time the view appears. Not just the first time the view loads. So if we go to another page (that has the navbar showing) and come back to this one, the navbar will hide.
    }
    
    private func setUpViews() {
        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(callToActionButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([ // Architecture: this is more effective
            // logoImageView
            logoImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 80
            ),
            logoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            logoImageView.heightAnchor.constraint(
                equalToConstant: 200
            ),
            logoImageView.widthAnchor.constraint(
                equalToConstant: 200
            ),
            
            // usernameTextField
            usernameTextField.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: 48
            ),
            usernameTextField.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 50
            ),
            usernameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -50
            ),
            usernameTextField.heightAnchor.constraint(
                equalToConstant: 50 // Architecture guidelines: should be at least 44
            ),
            
            // callToActionButton
            callToActionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -50
            ),
            callToActionButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 50
            ),
            callToActionButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -50
            ),
            callToActionButton.heightAnchor.constraint(
                equalToConstant: 50
            ),
        ])
    }
    
    private func setUpActions() {
        createDismissKeyboardTapGesture()
        callToActionButton.addTarget(
            self,
            action: #selector(pushFollowerListViewController),
            for: .touchUpInside
        )
        usernameTextField.delegate = self // The self is the SearchViewController. Here is where we are telling the view controller what to listen to. In this case we want it to listen to the usernameTextField
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self.view,
            action: #selector(UIView.endEditing)
        )
        view.addGestureRecognizer(tap)
    }
    
    @objc private func pushFollowerListViewController() { 
        // Passing the data
        //"Push viewController" shows newViewController. "Pop" shows previous one
        
        guard isUsernameEntered else { 
            presentGFAlertOnMainThread(
                title: "Empty username",
                message: "Please enter a username. We need to know who to look for",
                buttonTitle: "Ok"
            )
            return
        }
        let followerListViewController = FollowerListViewController()
        followerListViewController.username = usernameTextField.text
        followerListViewController.title = usernameTextField.text
        navigationController?.pushViewController(followerListViewController, animated: true)
    }
}

// Architecture: A delegate just sits back and listens (ex: tableViewDelegate, UIScrollViewDelegate, textFieldDelegate etc). "When this action happens, I will act on this."
// Compartmentalize the code in extensions - delegate conformations go on extensions

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListViewController()
        return true
    }
}
