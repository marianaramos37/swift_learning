import Foundation

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    static func retrieveFavourites(completed: @escaping (Result <[Follower], GFError>) -> Void) {
        guard let favouritesData = defaults.object(forKey: <#T##String#>)
    }
}
