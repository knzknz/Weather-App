import Foundation

class ForecastAPIClient {
    private init() {}
    static let manager = ForecastAPIClient()
    private let accessID = "ZIG2zbyoJlEjA6D92wy5m"
    private let secretKey = "LIBAhKNj2TZqpDlmj1GpCYZEDMGEgzGIkixkMGIr"
    
    func getForecast(completionHandler: @escaping ([Forecast]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlStr = "http://api.aerisapi.com/forecasts/11101?client_id=\(accessID)&client_secret=\(secretKey)"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badUrl)
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoForecast: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(ForecastInfoWrapper.self, from: data)
                if let response = results.response.first?.periods {
                    let forecasts = response
                    completionHandler(forecasts)
                }
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoForecast, errorHandler: errorHandler)
    }
}
