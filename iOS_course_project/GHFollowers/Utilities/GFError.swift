import Foundation

enum GFError: String, Error {

    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your reuest. Please check your internet connection"
    case invalidResponse = "Ivalid response from the server. Please try again."
    case invalidData = "The data received from server was invalid. Please try again."
}
