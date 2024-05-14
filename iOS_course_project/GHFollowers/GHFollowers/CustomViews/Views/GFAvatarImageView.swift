import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: "avatar_placeholder")
    
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
        clipsToBounds = true
        image = placeholderImage
    }
    
    func configure(with urlString: String) {
        // If we have the cached image:
        if let image = NetworkManager.shared.cache.object(forKey: NSString(string: urlString)) {
            self.image = image
            return
        }
        
        //If we don't:
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data)
            else {
                return
            }
            
            NetworkManager.shared.cache.setObject(image, forKey: NSString(string: urlString))
            
            //Updates of UI are allways done in the main thread:
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        task.resume()
    }
}
