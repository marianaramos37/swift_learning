import UIKit

/*
 Architecture:
 - Reusable components.
 - We name all our custom stuff with GF, so we know we created it
 - Separate all the UILogic from the view controller.
 - Every time we build a custom element it comes with a cost (of mantaining it etc), is up to us to decide if that cost is worth it or not
 */

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        // There is a repo called semantic UI that is an app with all semantic things.
        configure()
    }
    
    required init?(coder: NSCoder) { // This is called when we initialize the GFButton with the story board
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        // Dynamic type -> this font allows users to increase the size of the fonts in the phone settings
        // It is possible for custom fonts to conform to dynamic type. But its extra work.
    }
    
    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
