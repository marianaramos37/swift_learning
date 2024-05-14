import UIKit

class GFTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor //for layers we need to so CGColors
        
        placeholder = "Enter username"
        textColor = .label // this is black on white mode and white on dark mode
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true // font shrinks if username is too big
        minimumFontSize = 12 // but I set a minimum so it doen't shrink too much
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no // we don't want autocorrect in the username
        
        returnKeyType = .go // This is just the text of the retur button of the keyboard
    }
}
