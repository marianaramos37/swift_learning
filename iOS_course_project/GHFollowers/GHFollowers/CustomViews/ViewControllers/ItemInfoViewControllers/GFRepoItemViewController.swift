import UIKit

class GFRepoItemViewController: GFItemInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoViewOne.configure(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.configure(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}
