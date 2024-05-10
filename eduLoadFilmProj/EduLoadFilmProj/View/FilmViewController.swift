import UIKit

final class FilmViewController: UIViewController {
    //Assignment done to get acces to service part
    let movieService = LoadListFilmService()
    
    //The array of movies used while loading tableView
    var movies: [Movie] = []
    
    //Page number is used both for counting purposes and for instructing the API link about which movie page is currently required for loading.
    var currentPage: Int = 1
    
    //User interface tableView initialises at first request
//    lazy var tableView: UITableView = {
//        //Interface configuration for table
//        let view = UITableView(frame: view.bounds, style: .plain)
//        
//        //setting delegate and data source for table view
//        view.delegate = self
//        view.dataSource = self
//        
//        //Registering cell
//        view.register(TableViewFilmCell.self, forCellReuseIdentifier: TableViewFilmCell.reuseIdentifier)
//        return view
//    }()
    
    //Center spinner UI showing when page is loading and stops when loaded
    lazy var centerSpinner: UIActivityIndicatorView = {
        let centerSpinner = UIActivityIndicatorView(style: .large)
        centerSpinner.translatesAutoresizingMaskIntoConstraints = false
        return centerSpinner
    }()
    
    //Bottom spinner UI showing when page is loading  and stops when loaded
    lazy var bottomSpinner: UIActivityIndicatorView = {
        let bottomSpinner = UIActivityIndicatorView(style: .large)
        bottomSpinner.translatesAutoresizingMaskIntoConstraints = false
        return bottomSpinner
    }()
    
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
        
    }
    
    //setting up table view
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewFilmCell.self, forCellReuseIdentifier: TableViewFilmCell.reuseIdentifier)
        view.addSubview(tableView)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
        if indexPath.row == movies.count - 1  {
            print("Last cell of a current page")
            loadNextPage()
        }
    }
    
}

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
    private func loadMovies() {
        startCenterSpinner()
        self.movieService.fetchMovies(page: self.currentPage) { result in
            switch result {
            case .success(let movies):
                self.movies += movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.stopCenterSpinner()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    self.stopCenterSpinner()
                }
            }
        }
        
    }
    
    private func loadNextPage() {
        currentPage += 1
        
        startBottomSpinner()
        self.movieService.fetchMovies(page: self.currentPage) { result in
            switch result {
            case .success(let movies):
                self.movies += movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.stopBottomSpinner()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    self.stopBottomSpinner()
                }
            }
        }
        
    }
    
}
