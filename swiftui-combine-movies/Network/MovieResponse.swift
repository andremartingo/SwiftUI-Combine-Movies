import Foundation

struct MovieResponse {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
}

extension MovieResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
