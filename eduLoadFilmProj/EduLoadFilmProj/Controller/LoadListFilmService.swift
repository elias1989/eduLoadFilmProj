import Foundation
import UIKit

//Protocol for auto-tests, Controller re-use purpose, replace the Service.
protocol LoadListFilmProtocol {
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
    
}

//Sevice for movies uploading with no option to be inherit.
final class LoadListFilmService: LoadListFilmProtocol {
    //api key
    private let apiKey = "feacf88cd81377f6cfa24e512f1c61de"
    
    //get movies at API link with the given page.
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        //API link
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)"
        
        //check if url API can be found.
        guard let url = URL(string: urlString) else {
            let urlError = NSError(domain: "URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(urlError))
            return
        }
        
        //if link found checking if
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            //Check if exists data, downcasted response and error is nil.
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                let networkError = NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error in network request"])
                completion(.failure(networkError))
                return
            }
            
            // Response status code, decoding MovieResponse from the received data above with two outcomes - success and failure.
            if 200 ..< 300 ~= httpResponse.statusCode {
                do  {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MoviesResponse.self, from: data)
                    let movies = result.results
                    completion(.success(movies))
                } catch {
                    print("Error decoding JSON: \(error)")
                    let decodingError = NSError(domain: "Decoding", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error decoding JSON: \(error)"])
                    completion(.failure(decodingError))
                }
            } else {
                print("HTTP Response Error: \(httpResponse.statusCode)")
                let httpResponseError = NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Response Error: \(httpResponse.statusCode)"])
                completion(.failure(httpResponseError))
            }
        }.resume()
        
    }
    
}
