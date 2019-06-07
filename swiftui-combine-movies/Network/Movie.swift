import Foundation
import SwiftUI

struct Movie: Identifiable, Hashable {
    
    // MARK: Properties
    
    let title: String
    let id: Int
    let posterPath: String?
    var image: Data?
    var budget: Int?
    var voteAverage: Double?
    var status: String?
    var overview: String?
    
    init(title: String,
         id: Int,
         posterPath: String? = nil,
         image: Data? = nil,
         budget: Int? = nil,
         voteAverage: Double? = nil,
         status: String? = nil,
         overview: String? = nil) {
        
        self.title = title
        self.id = id
        self.posterPath = posterPath
        self.image = image
        self.budget = budget
        self.voteAverage = voteAverage
        self.status = status
        self.overview = overview
    }
}

extension Movie: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case posterPath = "poster_path"
        case image
        case budget
        case voteAverage = "vote_average"
        case status
        case overview
    }
}
