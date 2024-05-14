import UIKit

// This is the native way to do network calls. Alamofire, Moia, provide all of this

class NetworkManager {
    
    static let shared = NetworkManager() // With static every networkManager will have this variable on it
    let cache = NSCache<NSString, UIImage>() // Architecture: We create the cache here because this is a singleton. And so we will only have one instance of it.
    
    private let baseURL = "https://api.github.com/users/"
    
    private init() {} // Private because since this is a singleton we don't want it to be initialized anywhere else
    
    // "completion handler" = "closure"
    // Closures can be escaping or non escaping. An escaping closure can outlive the getFollowers function. It is basically used for asyncrounous stuff like our task (the closure can be called after a period of time).
    // The getFollowers either returns an array of followers ([Follower]?) or an error (String?)
    func getFollowers(
        for username: String,
        page: Int,
        completion: @escaping (Result<[Follower], GFError>) -> Void
    ) {
        
        let perPage = 100
        let endpoint = baseURL + "\(username)/followers?per_page=\(perPage)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            // We can't call our alert from here. Because it allways needs to get called from the main thread. Not a background thread.
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error { // if error exists
                completion(.failure(.unableToComplete))
                 return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder() // Decoder decodes data into our objects
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // Here we add the .self because we want the type of [Follower]
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                // If try fails in throws an error here
                completion(.failure(.invalidData))
                return
            }
        }
        
        task.resume() // This starts our network call
    }
    
    func getUserInfo(
        for username: String,
        completion: @escaping (Result<User, GFError>) -> Void
    ) {
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
}
