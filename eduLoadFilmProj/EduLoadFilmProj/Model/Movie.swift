import Foundation

//struct Model - Movie described by the text labels
struct Movie: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    let posterImageView: String
    
    //keys needed for JSON code.
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case posterImageView = "poster_path"
    }
    
}

