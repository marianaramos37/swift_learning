import UIKit
import SafariServices

// Sometimes subclassing to a new viewcontroller may be a better ideia then extensions,
// because in extentions we cannot have store properties (vars and lets)

// Global variable
fileprivate var containerView: UIView!

extension UIViewController {
    
    // Architecture: it is ilegal to present a UIElement from the background thread
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async { // quick way to throw things on main thread
            let alertViewController = GFAlertViewController(
                title: title,
                message: message,
                buttonTitle: buttonTitle
            )
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve // fades in
            self.present(alertViewController, animated: true) //"self." because we are inside a closure here
        }
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func presentSafariViewController(with url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .systemGreen
        present(safariViewController, animated: true)
    }
}
