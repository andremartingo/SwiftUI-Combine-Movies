import Foundation

enum API {
    
    static let baseURL = URL(string: "https://api.themoviedb.org")!
    static let imageURL = URL(string: "https://image.tmdb.org")!
    static let key = "7be6194ecfdd01d72a963df3355bb7d2"
    
    enum ImageSize {
        case big
        case small
        
        var size: String {
            switch self {
            case .big:
                return "w780"
            default:
                return "w185"
            }
        }
    }
    
    enum Endpoint {
        
        case popular
        case image(id: String, size: ImageSize)
        case search(term: String)
        case details(id: Int)
        
        var path: String {
            
            switch self {
            case .popular:
                return "/3/movie/popular"
                
            case .image(let id, let size):
                return "/t/p/\(size.size)\(id)"
                
            case .search(_):
                return "/3/search/movie"
                
            case .details(let id):
                return "/3/movie/\(id)"
            }
        }
        
        var method: HTTP.Method {
            
            return .get
        }
        
        var query: HTTP.Query {
            
            switch self {
            case .popular:
                
                return [
                    "api_key": API.key,
                    "format": "json",
                ]
                
            case .image(_):
                
                return [
                    "api_key": API.key,
                    "format": "json",
                ]
                
            case .search(let term):
                
                return [
                    "api_key": API.key,
                    "query": term,
                    "format": "json",
                ]
            case .details(_):
                
                return [
                    "api_key": API.key,
                    "format": "json",
                ]
            }
            
        }
    }
}
