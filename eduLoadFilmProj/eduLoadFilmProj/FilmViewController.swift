import UIKit

class FilmViewController: UIViewController {

    var tableView: UITableView!
    
    var movies: [Movie] = []

    let movieService = LoadListFilmService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        
        //Strong reference overwrited each time viewdidload called. No need for [weak self]
        movieService.fetchMovies {  movies in
            if let movies = movies {
                self.movies = movies     //если стоит [weak self] тогда нужен self?(опциональный). как это может не найтись, оно объявдено выше
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Fail")
            }
        }
    }

    private func setupNavigationBar() {
           let dismissButton = UIBarButtonItem(
               title: "Dismiss",
               style: .plain,
               target: self,
               action: #selector(dismissButtonTapped)
        )

           navigationItem.leftBarButtonItem = dismissButton
       }
    
    
    @objc private func dismissButtonTapped() {
        //navigationController?.popViewController(animated: true) не работает.
        dismiss(animated: true)
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
        return cell
    }
}
