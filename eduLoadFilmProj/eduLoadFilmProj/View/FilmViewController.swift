import UIKit

class FilmViewController: UIViewController {

    var tableView: UITableView!
    
    var movies: [Movie] = []
    
    let movieService = LoadListFilmService()
    
    var isLoadingNextPage: Bool = false
    var currentPage: Int = 1
    
    var centerSpinner: UIActivityIndicatorView!
    var isLoadingFirstTime: Bool = true
    
    
    var bottomSpinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        loadMovies()
        isLoadingFirstTime = false
        setupSpinners()
        startCenterSpinner()
        
    }
    
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewFilmCell.self, forCellReuseIdentifier: TableViewFilmCell.reuseIdentifier)
        view.addSubview(tableView)
    
    }
    
    
    private func loadMovies() {
        
    self.startBottomSpinner()
  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      
      
      
      self.movieService.fetchMovies(page: self.currentPage) { newMovies in
          if let movies = newMovies {
              self.movies += movies
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
          } else {
              print("Upload failed. No more pages")
          }
      }
           
      self.stopBottomSpinner()
      guard self.isLoadingFirstTime == true else { return self.stopCenterSpinner() }
            
    }
 }
        
    
    private func setupSpinners() {
        centerSpinner = UIActivityIndicatorView(style: .large)
        centerSpinner.center = view.center
        view.addSubview(centerSpinner)
        
        bottomSpinner = UIActivityIndicatorView(style: .large)
        bottomSpinner.center = CGPoint(x: view.center.x, y: view.bounds.height - 10)
        view.addSubview(bottomSpinner)
    }
    
    
    private func startCenterSpinner() {
            centerSpinner.startAnimating()
        }
    
    private func stopCenterSpinner() {
            centerSpinner.stopAnimating()
        }
    
    
    //to be continues. bottom spinner found nil.
    private func startBottomSpinner() {
            bottomSpinner.startAnimating()
        }

        private func stopBottomSpinner() {
            bottomSpinner.stopAnimating()
        }
    
    
    func loadNextPage() {
        guard !isLoadingNextPage else {
                  return
              }

        isLoadingNextPage = true
        currentPage += 1
        
        
       // startBottomSpinner()
        loadMovies()
        //stopBottomSpinner()
        
        isLoadingNextPage = false
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
            print(indexPath.row)
            
            //tableView.scrollToRow(at: indexPath.row - 1, at: .top, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            //Check if the last cell is displayed
            if indexPath.row == movies.count - 1 && !isLoadingNextPage {
               print("this is the last page")
                loadNextPage()
            }
        }
    
}

