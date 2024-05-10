import Foundation

struct Movie: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case title, overview
        case releaseDate = "release_date"
    }
    
}

