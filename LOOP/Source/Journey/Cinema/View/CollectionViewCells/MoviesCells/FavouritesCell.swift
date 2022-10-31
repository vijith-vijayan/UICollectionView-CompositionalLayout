//
//  Created by Vijith on 21/10/2022.
//
import UIKit
import Combine

class FavouritesCell: UICollectionViewCell {
    
    // MARK: - DEPENDENCY INJECTION
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    @Injected(\.imageLoader)
    private var imageLoaderService: ImageLoaderService
    private lazy var useCase: MovieUseCase = {
        return MovieUseCase(imageLoaderService: imageLoaderService)
    }()
    
    // MARK: - UI ELEMENTS
    /// POSTER IMAGEVIEW
    lazy var posterImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.accessibilityIdentifier = AccessibilityIdentifiers.FavouritesCell.posterImageViewId
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private var cancellable: AnyCancellable?
    
    // MARK: - INITIALISER
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LAYOUT SUBVIEWS
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadowLayer()
        applyStyles()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelImageLoading()
    }
    
    // MARK: - SETUP IMAGEVIEW
    private func setupImageView() {
        self.addSubview(posterImageView)
        applyConstraints()
    }
    
    // MARK: - APPLY CONSTRAINTS
    private func applyConstraints() {
        NSLayoutConstraint.activate(
            [
                posterImageView.topAnchor.constraint(equalTo: topAnchor),
                posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    // MARK: - APPLY STYLES
    private func applyStyles() {
        configuration.movies.design.style.posterImageViewStyle.apply(to: posterImageView)
    }
    
    // MARK: - SET IMAGE IN IMAGEVIEW
    func setup(_ movie: Movie) {
        cancellable = useCase.loadImage(for: movie).sink { [weak self] image in
            let scaledImage = image?.scalePreservingAspectRatio(targetSize: self?.posterImageView.bounds.size ?? .zero)
            self?.posterImageView.image = scaledImage
        }
    }
    
    func cancelImageLoading() {
        posterImageView.image = nil
        cancellable?.cancel()
    }
}
