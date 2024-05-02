import UIKit

final class FilmViewController: UIViewController {
    
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: view.bounds, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.register(TableViewFilmCell.self,
                      forCellReuseIdentifier: TableViewFilmCell.reuseIdentifier)
        return view
    }()
    
    
    var movies: [Movie] = []
    
    let movieService = LoadListFilmService()
    
    var isLoadingNextPage: Bool = false
    var currentPage: Int = 1
    
    lazy var centerSpinner: UIActivityIndicatorView = {
        let centerSpinner = UIActivityIndicatorView(style: .large)
        centerSpinner.translatesAutoresizingMaskIntoConstraints = false
        return centerSpinner
    }()
        
    lazy var bottomSpinner: UIActivityIndicatorView = {
        let bottomSpinner = UIActivityIndicatorView(style: .large)
        bottomSpinner.translatesAutoresizingMaskIntoConstraints = false
        return bottomSpinner
        
    }()
    
    var isLoadingFirstTime: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        view.addSubview(centerSpinner)
        NSLayoutConstraint.activate([
            centerSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(bottomSpinner)
        NSLayoutConstraint.activate([
            bottomSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomSpinner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])

        loadMovies()
        isLoadingFirstTime = false
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
            self.movieService.fetchMovies(page: self.currentPage) { (newMovies, error) in
                
                if let movies = newMovies {
                    self.movies += movies
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.stopCenterSpinner()
                    }
                    
                } else if let error = error {
                    
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        self.stopCenterSpinner()
                    }
                    
                }
                
                
                
            }
        
        
    }
    
    
//    private func setupSpinners() {
//        centerSpinner = UIActivityIndicatorView(style: .large)
//        centerSpinner.center = view.center
//        view.addSubview(centerSpinner)
//        
//        bottomSpinner = UIActivityIndicatorView(style: .large)
//        bottomSpinner.center = CGPoint(x: view.center.x, y: view.bounds.height - 30)
//        view.addSubview(bottomSpinner)
//    }
    
    
    private func startCenterSpinner() {
        centerSpinner.startAnimating()
    }
    
    private func stopCenterSpinner() {
        centerSpinner.stopAnimating()
    }
    
    private func startBottomSpinner() {
        bottomSpinner.startAnimating()
    }
    
    private func stopBottomSpinner() {
        bottomSpinner.stopAnimating()
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadNextPage() {
        guard !isLoadingNextPage else {
            return
        }
        
        isLoadingNextPage = true
        currentPage += 1
        
        startBottomSpinner()
        
            self.movieService.fetchMovies(page: self.currentPage) { (newMovies, error) in
                if let movies = newMovies {
                    self.movies += movies
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.stopBottomSpinner()
                        self.isLoadingNextPage = false
                    }
                } else if let error = error {
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        
                    }
                }
                
            }
            
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 && !isLoadingNextPage {
            print("Last cell of a current page")
            loadNextPage()
        }
    }
    
}

