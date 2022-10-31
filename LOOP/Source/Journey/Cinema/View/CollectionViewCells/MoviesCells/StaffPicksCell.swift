//
//  Created by Vijith on 23/10/2022.
//

import UIKit
import Combine
import CoreData

class StaffPicksCell: UICollectionViewCell {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    @Injected(\.imageLoader)
    private var imageLoaderService: ImageLoaderService
    
    private lazy var useCase: MovieUseCase = {
        return MovieUseCase(imageLoaderService: imageLoaderService)
    }()
    
    // MARK: - UI ELEMENTS
    lazy var posterImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.accessibilityIdentifier = "staffPicksImageView"
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = DesignSystem.shared.cornerRadius.medium
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = "stackPicksStackView"
        return stackView
    }()
    
    lazy var ratingContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var starView: StarRatingView = {
        let starView = StarRatingView()
        starView.starRounding = .roundToFullStar
        starView.size = CGSize(width: DesignSystem.shared.sizers.sm + 2, height: DesignSystem.shared.sizers.sm + 1)
        starView.spacing = 2
        starView.translatesAutoresizingMaskIntoConstraints = false
        return starView
    }()
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(configuration.movies.design.favouriteHollowIcon, for: .normal)
        button.addTarget(self, action: #selector(bookmarkPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var separtorView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.shared.colors.white40
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var bag: AnyCancellable?
    private let dbManager: DBManager = DBManager<MoviesEntity>()
    private var cancellables: [AnyCancellable] = []
    
    var bookmark: ((Int, Bool) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancelImageLoading()
    }
    
    func setup() {
        applyStyles()
        addSubViews()
        applyConstraints()
    }
    
    func applyStyles() {
        configuration.movies.design.style.yearLabelStyle.apply(to: yearLabel)
        configuration.movies.design.style.movieLabelStyle.apply(to: movieNameLabel)
    }
    
    func addSubViews() {
        addSubview(posterImageView)
        addSubview(vStackView)
        addSubview(favouriteButton)
        addSubview(separtorView)
        ratingContainerView.addSubview(starView)
        
        vStackView.addArrangedSubview(yearLabel)
        vStackView.addArrangedSubview(movieNameLabel)
        vStackView.addArrangedSubview(ratingContainerView)
        vStackView.setCustomSpacing(DesignSystem.shared.sizers.xs, after: movieNameLabel)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate(
            [
                posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystem.shared.sizers.xl),
                posterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                posterImageView.widthAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 2),
                posterImageView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 3),
                
                favouriteButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                          constant: -DesignSystem.shared.sizers.xl * 1.05),
                favouriteButton.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl),
                favouriteButton.widthAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl),
                favouriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                vStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor,
                                                    constant: DesignSystem.shared.sizers.lg),
                vStackView.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor,
                                                     constant: -DesignSystem.shared.sizers.md),
                vStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                vStackView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 1.6),
                
                starView.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),
                starView.leadingAnchor.constraint(equalTo: ratingContainerView.leadingAnchor),
                starView.topAnchor.constraint(equalTo: ratingContainerView.topAnchor),
                starView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor),
                
                separtorView.trailingAnchor.constraint(equalTo: favouriteButton.trailingAnchor),
                separtorView.heightAnchor.constraint(equalToConstant: 1),
                separtorView.widthAnchor.constraint(equalToConstant: self.bounds.width / 1.6),
                separtorView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    func setupDTO(_ movie: Movie) {
        bag = useCase.loadImage(for: movie).sink { [weak self] image in
            let scaledImage = image?.scalePreservingAspectRatio(targetSize: self?.posterImageView.bounds.size ?? .zero)
            self?.posterImageView.image = scaledImage
        }
        let date = configuration.movies.uiDataMapper.date(movie.releaseDate, .default)
        let year = configuration.movies.uiDataMapper.yearFromDate(date)
        yearLabel.text = year
        movieNameLabel.text = movie.title
        if let ratings = movie.rating {
            starView.isHidden = false
            starView.rating = Float(ratings.rounded())
            starView.starColor = (DesignSystem.shared.colors.gold, DesignSystem.shared.colors.white40)
            starView.starCount = 5
        } else {
            starView.isHidden = true
        }
        favouriteButton.tag = movie.id ?? 0
        fetchDataFromDB(for: movie.id ?? 0)
    }
    
    func cancelImageLoading() {
        posterImageView.image = nil
        bag?.cancel()
    }
    
    @objc
    func bookmarkPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setImage(configuration.movies.design.favouriteFilledIcon, for: .normal)
            bookmark?(sender.tag, true)
        } else {
            sender.setImage(configuration.movies.design.favouriteHollowIcon, for: .normal)
            bookmark?(sender.tag, false)
        }
    }
    
    func fetchDataFromDB(for id: Int) {
        let predicate = NSPredicate(format: "movieId == %@", "\(id)")
        DBOperations.shared.fecthBookmarkFromDB(with: predicate) { [weak self] status in
            self?.updateBookmark(with: status)
        }
    }
    
    func updateBookmark(with status: Bool) {
        if status {
            favouriteButton.setImage(configuration.movies.design.favouriteFilledIcon, for: .normal)
        } else {
            favouriteButton.setImage(configuration.movies.design.favouriteHollowIcon, for: .normal)
        }
    }
}
