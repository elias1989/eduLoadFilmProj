import UIKit

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
    
    //creating initializers for custom table view cell.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(overviewLabel)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            releaseDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            posterImageView.widthAnchor.constraint(equalToConstant: 50),
            posterImageView.heightAnchor.constraint(equalToConstant: 75),
            
        ])
        
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
        posterImageView.image = movie.posterImageView
        
    }
    
}
