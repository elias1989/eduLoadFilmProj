import UIKit

//UI related Controller + business logic
final class FilmViewController: UIViewController {
    
    //Protocol usage by movieService
    let movieService: LoadListFilmProtocol
    
    
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
        
        //shows tableView on the screen
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
        
        //adding table view with further initialization.
        view.addSubview(tableView)
        
        //loading of the first page
        loadMovies()
        
    }
    
    //Alert in case errors. Shows the type of error depending on context.
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

//table view UI. amount of movies on the screen, configuration of each cell, detecting the last cell on the scren to load the next page.
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

//Loading "first page" and "next page" methods
extension FilmViewController {
    private func loadMovies() {
        //Star animation
        startCenterSpinner()
        
        //Referring to Service part to load the first page of the moview array.
        self.movieService.fetchMovies(page: self.currentPage) { result in
            switch result {
                
            //In case of succes movies added to array. Table UI with movies refreshes with new data. Spinner Disappears.
            case .success(let movies):
                self.movies += movies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.stopCenterSpinner()
                }
                
            //In case of failure refering to alert to show the Erorr type depending on the context. Spinner disappears.
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    self.stopCenterSpinner()
                }
            }
        }
        
    }
    
    //Loading the next page. Same idea as in previous LoadMovies() method, but with current page number.
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
