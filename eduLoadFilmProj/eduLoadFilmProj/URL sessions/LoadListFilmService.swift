import Foundation

class LoadListFilmService {

    private let apiKey = "feacf88cd81377f6cfa24e512f1c61de"
    
    func fetchMovies(completion: @escaping ([Movie]?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=1"
        
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
        
            URLSession.shared.dataTask(with: url) { data, _, error in
                //response statusCode == 200 check?
                guard let data = data, error == nil else {
                    completion(nil)
                    return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MoviesResponse.self, from: data)
                let movies = result.results
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 100, execute: {
//                                    completion(movies)
//                                } )
                
                completion(movies)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
            
        }.resume()
    }
    
}