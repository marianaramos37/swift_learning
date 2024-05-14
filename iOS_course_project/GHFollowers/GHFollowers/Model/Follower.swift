import Foundation

struct Follower: Codable, Hashable {
    // Note: When we use codable, our variable names have to match what is in the data structure
    // Codable = Encodable + Decodable
    // What is in the data structure as snake case it automatically converts to Camel case
    // That is why we have avatarUrl instead of avatar_url (in swift we tipically don't use snake case)
    
    // Since both parameters are strings, and they are both hashables, we can put hashable on top. If not we could
    // write our hash function. Something like:
    // func hash(into hasher: inout Hasher) {
    //      hasher.combine(login)
    // }
    // This would only hash the login parameter.
    
    var login: String // this is our username
    var avatarUrl: String
}
