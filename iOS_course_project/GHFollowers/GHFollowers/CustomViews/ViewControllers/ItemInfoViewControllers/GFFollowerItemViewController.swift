import UIKit

class GFFollowerItemViewController: GFItemInfoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoViewOne.configure(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.configure(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
