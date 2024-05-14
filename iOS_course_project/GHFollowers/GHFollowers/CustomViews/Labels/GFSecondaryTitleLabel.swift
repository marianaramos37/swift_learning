import UIKit

// Architecture:
// choice on having titleLabel, secondaryTitleLabel and bodyLabel has tradeoffs. We could have only one generic label that was flexible and would receive a size and other things. But there is balance on making things more easy to use and obvious, and easy to change. Its basically: generic, flexible and reusable VS straightford and simple to use.

class GFSecondaryTitleLabel: UILabel {

    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
    }
}
