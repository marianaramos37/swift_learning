import UIKit

class GFBodyLabel: UILabel {

    init(textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping // it changes line
        font = UIFont.preferredFont(forTextStyle: .body)
    }
}
