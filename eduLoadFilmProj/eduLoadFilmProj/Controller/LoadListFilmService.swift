import Foundation
import UIKit

class LoadListFilmService: UIViewController {
    
    private let apiKey = "feacf88cd81377f6cfa24e512f1c61de"
    
    
    func fetchMovies(page: Int, completion: @escaping ([Movie]?, Error?) -> Void) {
        
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            let urlError = NSError(domain: "URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, urlError)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil else {
                let networkError = NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error in network request"])
                completion(nil, networkError)
                return
            }
            
            
            if 200 ..< 300 ~= httpResponse.statusCode {
                do  {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(MoviesResponse.self, from: data)
                    let movies = result.results
                    completion(movies, nil)
                } catch {
                    print("Error decoding JSON: \(error)")
                    let decodingError = NSError(domain: "Decoding", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error decoding JSON: \(error)"])
                    completion(nil, decodingError)
                }
                
            } else {
                print("HTTP Response Error: \(httpResponse.statusCode)")
                let httpResponseError = NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Response Error"])
                completion(nil, httpResponseError)
            }
            
        }.resume()
        
        
        func showAlert(with title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
}
