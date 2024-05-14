import Foundation


// Enum Associated Values:
// - Declare type after each case

// Enum Raw Values:
// - Define the type after the enum (String), and then all cases conform to that type

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
