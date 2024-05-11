import Foundation

//struct Model - Movie described by the text labels
struct Movie: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    
    //keys needed in JSON code.
    enum CodingKeys: String, CodingKey {
        case title, overview
        case releaseDate = "release_date"
    }
    
}

