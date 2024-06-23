import UIKit
import SDWebImage

class TableViewFilmCell: UITableViewCell {
    
    //identification mark for cell
    static let reuseIdentifier = "MovieCell"
    
    //creating labels for cell with immediate initiailization
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        return label
    }()
    private let posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.lightGray.cgColor
        return posterImageView
    }()
    
    //Сreating initializers for custom table view cell.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Location configuration constants for titleLabel, overviewLabel, posterImageView
    let topPadding: CGFloat = 8.0
    let leadingPadding: CGFloat = 70.0
    let trailingPadding: CGFloat = -16.0
    let bottomPadding: CGFloat = -8.0
    let posterImageTopPadding: CGFloat = 8.0
    let posterImageLeadingPadding: CGFloat = 8.0
    let posterImageWidth: CGFloat = 50.0
    let posterImageHeight: CGFloat = 75.0
    
    private func setupUI() {
        //User interface setup for various objects
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(overviewLabel)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topPadding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingPadding),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topPadding),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingPadding),
            
            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: topPadding),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leadingPadding),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailingPadding),
            releaseDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomPadding),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: posterImageTopPadding),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: posterImageLeadingPadding),
            posterImageView.widthAnchor.constraint(equalToConstant: posterImageWidth),
            posterImageView.heightAnchor.constraint(equalToConstant: posterImageHeight),
        ])
        
    }
    
    //Assigning data for the certain cell
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
        loadImage(for: movie)
    }
    
}

extension TableViewFilmCell {
    //asynchronous loading of Image for the cell.
    private func loadImage(for movie: Movie) {
        if let posterImageURL = movie.posterImageURL {
            print("Loading image from URL: \(posterImageURL)")
            posterImageView.sd_setImage(with: posterImageURL) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error)")
                } else {
                    print("Image loaded successfully from URL: \(url?.absoluteString ?? "No URL")")
                }
            }
        } else {
            print("Invalid URL string: \(movie.posterImagePath)")
            posterImageView.image = UIImage(named: "poster_path")
        }
    }
    
}
