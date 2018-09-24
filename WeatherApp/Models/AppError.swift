import Foundation

enum AppError: Error {
    case noData
    case badUrl
    case badJSON
    case noInternet
    case codingError(rawError: Error)
    case urlError(rawError: Error)
    case otherError(rawError: Error)
}


