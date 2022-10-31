//
//  Created by Vijith TV on 28/10/22.
//

import UIKit
import Combine

class MainFactsCell: UICollectionViewCell, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    @Injected(\.imageLoader)
    private var imageLoaderService: ImageLoaderService
    
    private lazy var useCase: MovieUseCase = {
        return MovieUseCase(imageLoaderService: imageLoaderService)
    }()
    
    lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var ratingContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let posterImageShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var ratingView: StarRatingView = {
        let ratingView = StarRatingView()
        ratingView.spacing = 2
        ratingView.starRounding = .roundToFullStar
        ratingView.size = CGSize(width: DesignSystem.shared.sizers.md, height: DesignSystem.shared.sizers.md - 2)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        return ratingView
    }()
    
    lazy var dateAndDurationLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tagList: TagListView = {
        let tagList = TagListView(type: .genre)
        tagList.translatesAutoresizingMaskIntoConstraints = false
        return tagList
    }()
    
    lazy var tagView: UIView = {
        let tagView = UIView()
        tagView.translatesAutoresizingMaskIntoConstraints = false
        return tagView
    }()
    
    private var bag: AnyCancellable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyStyles()
        posterImageShadowView.addShadowLayer()
    }
    
    func setup() {
        addSubviews()
        applyConstraints()
    }
    
    func applyStyles() {
        configuration.movies.design.style.movieHeaderCellTitleLabelStyle.apply(to: movieTitleLabel)
        configuration.movies.design.style.posterImageViewStyle.apply(to: posterImageView)
        configuration.movies.design.style.movieDurationLabelStyle.apply(to: dateAndDurationLabel)
        configuration.movies.design.style.tagListViewSearchStyle.apply(to: tagList)
    }
    
    func addSubviews() {
        addSubview(posterImageShadowView)
        addSubview(vStackView)
        posterImageShadowView.addSubview(posterImageView)
        ratingContainerView.addSubview(ratingView)
        vStackView.addArrangedSubview(ratingContainerView)
        vStackView.addArrangedSubview(dateAndDurationLabel)
        vStackView.addArrangedSubview(movieTitleLabel)
        vStackView.addArrangedSubview(tagList)
                
        vStackView.setCustomSpacing(DesignSystem.shared.sizers.md, after: posterImageView)
        vStackView.setCustomSpacing(DesignSystem.shared.sizers.sm * 1.5, after: ratingContainerView)
        vStackView.setCustomSpacing(DesignSystem.shared.sizers.sm, after: dateAndDurationLabel)
        vStackView.setCustomSpacing(DesignSystem.shared.sizers.sm, after: movieTitleLabel)
    }
    
    func applyConstraints() {
        let constraints = [
            posterImageShadowView.topAnchor.constraint(equalTo: topAnchor, constant: DesignSystem.shared.sizers.xl),
            posterImageShadowView.widthAnchor.constraint(equalToConstant: 203),
            posterImageShadowView.heightAnchor.constraint(equalToConstant: 295),
            posterImageShadowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: posterImageShadowView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: posterImageShadowView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: posterImageShadowView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: posterImageShadowView.bottomAnchor),
            
            vStackView.topAnchor.constraint(equalTo: posterImageShadowView.bottomAnchor, constant: DesignSystem.shared.sizers.sm),
            vStackView.widthAnchor.constraint(equalToConstant:  bounds.width),
            vStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            ratingContainerView.heightAnchor.constraint(equalToConstant: 20),
            
            ratingView.centerXAnchor.constraint(equalTo: ratingContainerView.centerXAnchor),
            ratingView.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),
            ratingView.topAnchor.constraint(equalTo: ratingContainerView.topAnchor),
            ratingView.bottomAnchor.constraint(equalTo: ratingContainerView.bottomAnchor),
            
            tagList.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl)
        ]
        addConstraints(constraints)
    }
    
    func setupDTO(_ movie: Movie) {
        bag = useCase.loadImage(for: movie)
            .sink(receiveValue: { [weak self] image in
                guard let weakself = self else { return }
                let scaledImage = image?.scalePreservingAspectRatio(targetSize: CGSize(width:  203,
                                                                                       height: 295)).withRoundedCorners(radius: 14)
                weakself.posterImageView.image = scaledImage
            })
        if let genres = movie.genres {
            tagList.data = genres
        }
        if let title = movie.title, let releaseDate = movie.releaseDate {
            let date = configuration.movies.uiDataMapper.date(releaseDate, .default)
            let year = configuration.movies.uiDataMapper.yearFromDate(date)
            let formatedTitle = configuration.movies.uiDataMapper.movieDetailsHeaderTitleProvider(title, " (\(year))")
            movieTitleLabel.attributedText = formatedTitle
        }
        if let duration = configuration.movies.uiDataMapper.durationProvier(movie.runtime) {
            let date = configuration.movies.uiDataMapper.date("\(movie.releaseDate ?? "")", .default)
            let formattedDate = configuration.movies.uiDataMapper.stringFromDate(date, .dot)
            dateAndDurationLabel.text = "\(formattedDate) \(duration)"
        }
        
        if let rating = movie.rating {
            ratingView.starCount = 5
            ratingView.rating = Float(rating)
            ratingView.starColor = (DesignSystem.shared.colors.gold, DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0.2))
        }
    }
}
