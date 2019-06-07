import Foundation

struct HTTP {
    
    typealias Headers = [String: String]
    
    typealias Query = [String: String]
    
    enum Method: String {
        
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
    }
    
    enum StatusCode: Hashable {
        
        /// 1xx Informational
        case informational(Int)
        /// 2xx Success
        case success(Int)
        /// 3xx Redirection
        case redirection(Int)
        /// 4xx Client Error
        case clientError(Int)
        /// 5xx Server Error
        case serverError(Int)
        /// Unknown class error
        case unknownError(Int)
        
        /// The associated status code value.
        var statusCode: Int {
            switch self {
            case let .informational(statusCode),
                 let .success(statusCode),
                 let .redirection(statusCode),
                 let .clientError(statusCode),
                 let .serverError(statusCode),
                 let .unknownError(statusCode):
                return statusCode
            }
        }
        
        init(_ statusCode: Int) {
            switch statusCode {
            case 100...199: self = .informational(statusCode)
            case 200...299: self = .success(statusCode)
            case 300...399: self = .redirection(statusCode)
            case 400...499: self = .clientError(statusCode)
            case 500...599: self = .serverError(statusCode)
            default: self = .unknownError(statusCode)
            }
        }
    }
}

struct Resource: Equatable {
    
    // MARK: - Properties
    
    var baseURL: URL
    var path: String
    var method: HTTP.Method
    var headers: HTTP.Headers
    var body: Data?
    var query: HTTP.Query
    
    // MARK: - Lifecycle
    
    init(baseURL: URL,
         path: String,
         method: HTTP.Method,
         body: Data? = nil,
         headers: HTTP.Headers = [:],
         query: HTTP.Query = [:]) {
        
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.query = query
    }
}

extension Resource {
    
    func request() -> URLRequest {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = queryItems(from: query)
        components?.path = path
        
        let request = NSMutableURLRequest(url: components?.url ?? baseURL)
        
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        
        
        return request as URLRequest
    }
    
    func queryItems(from query: HTTP.Query) -> [URLQueryItem]? {
        
        guard query.isEmpty == false else { return nil }
        
        return query.map { (key, value) in URLQueryItem(name: key, value: value) }
    }
}
