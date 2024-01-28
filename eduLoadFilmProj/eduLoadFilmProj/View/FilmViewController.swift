import UIKit

class FilmViewController: UIViewController {

    var tableView: UITableView!
    
    var movies: [Movie] = []

    let movieService = LoadListFilmService()
    
    var isLoadingNextPage: Bool = false
    var currentPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadMovies()
       
    }
    
    private func loadMovies() {
        
        movieService.fetchMovies(page: currentPage) {  movies in
            
            if let movies = movies {
                self.movies = movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Fail")
            }
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewFilmCell.self, forCellReuseIdentifier: TableViewFilmCell.reuseIdentifier)
        view.addSubview(tableView)
    
    }
}


extension FilmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewFilmCell.reuseIdentifier, for: indexPath) as! TableViewFilmCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        
        if indexPath.row == movies.count - 1 && !isLoadingNextPage {
            loadNextPage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Check if the last cell is displayed
            if indexPath.row == movies.count - 1 && !isLoadingNextPage {
                loadNextPage()
            }
        }
    
}



extension FilmViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let scrollViewHeight = scrollView.frame.size.height
//
//        let isAtBottom = contentOffsetY + scrollViewHeight >= contentHeight
//
//        if isAtBottom && !isLoadingNextPage {
//            loadNextPage()
//        }
//
//    }
    
    func loadNextPage() {
        guard !isLoadingNextPage else {
                  return
              }

              isLoadingNextPage = true
              currentPage += 1

              loadMovies()
              isLoadingNextPage = false
    }
    
}
