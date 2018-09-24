import Foundation

struct ForecastInfoWrapper: Codable {
    let response: [Response]
}

struct Response: Codable {
    let periods: [Forecast]
}

struct Forecast: Codable {
    let dateTimeISO: String
    let maxTempC: Int
    let maxTempF: Int
    let minTempC: Int
    let minTempF: Int
    var icon: String
}
