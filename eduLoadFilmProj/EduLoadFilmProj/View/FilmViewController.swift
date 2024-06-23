import UIKit

//UI related Controller + business logic
final class FilmViewController: UIViewController {
    
    //LoadListFilmProtocol protocol usage by movieService
    let movieService: LoadListFilmProtocol
    
    //initialisation of various objects
    init(movieService: LoadListFilmProtocol, movies: [Movie] = [], currentPage: Int = 1) {
        self.movieService = movieService
        self.movies = movies
        self.currentPage = currentPage
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //The array of movies used to arrange the sequence of loaded movies.
    var movies: [Movie] = []
    
    //Page number is used both for counting purposes and for instructing the API link about which movie page is currently required for loading.
    var currentPage: Int = 1
    
    //UI table View initialized at first request
    lazy var tableView: UITableView = {
        //Interface configuration for table
        let view = UITableView(frame: view.bounds, style: .plain)
        
        //Assigning FilmViewController as a delegate and datasource for the view.
        view.delegate = self
        view.dataSource = self
        
        //Registering cell
        view.register(TableViewFilmCell.self, forCellReuseIdentifier: TableViewFilmCell.reuseIdentifier)
        
        //Shows tableView on the screen
        return view
    }()
    
    //Center spinner UI showing when page is loading and stops when loaded
    lazy var centerSpinner: UIActivityIndicatorView = {
        let centerSpinner = UIActivityIndicatorView(style: .large)
        centerSpinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerSpinner)
        NSLayoutConstraint.activate([
            centerSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return centerSpinner
    }()
    
    //Bottom spinner UI showing when page is loading and stops when loaded
    lazy var bottomSpinner: UIActivityIndicatorView = {
        let bottomSpinner = UIActivityIndicatorView(style: .large)
        bottomSpinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSpinner)
        NSLayoutConstraint.activate([
            bottomSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomSpinner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        return bottomSpinner
    }()
    
    //First actions in lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding table view with further initialization.
        view.addSubview(tableView)
        
        //Loading movies
        loadMovies()
        
    }
    
    //Alert in case errors. Shows the type of error depending on context.
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Stop center OR bottom spinner dependind on the page.
    private func stopSpinner() {
        if currentPage == 1 {
            stopCenterSpinner()
        } else {
            stopBottomSpinner()
        }
    }

}

//Table view UI. amount of movies on the screen, configuration of each cell, detecting the last cell on the scren to load the next page.
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
        if indexPath.row == movies.count - 1  {
            print("Last cell of a current page")
            loadMovies()
        }
    }
    
}

// Spinners Start/Stop animation functions depending on the context.
extension FilmViewController {
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
    
}

extension FilmViewController {
    //Loading page method
    private func loadMovies() {
        currentPage += 1
        if currentPage == 1 { startCenterSpinner() } else { startBottomSpinner() }
        movieService.fetchMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                self.movies += movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.stopSpinner()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    self.stopSpinner()
                }
            }
        }
    }
    
}
