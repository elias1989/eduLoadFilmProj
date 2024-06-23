import Foundation
import UIKit

//struct Model - Movie described by the text labels
struct Movie: Codable {
    let title: String
    let overview: String
    let releaseDate: String
    let posterImagePath: String 
    
    //keys needed for JSON code.
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case posterImagePath = "poster_path"
    }
    
    //creating URL object
    var posterImageURL: URL? {
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterImagePath)")
    }
    
}

