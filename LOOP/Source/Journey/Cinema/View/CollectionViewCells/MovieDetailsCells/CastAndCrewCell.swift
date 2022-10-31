//
//  Created by Vijith TV on 30/10/22.
//

import UIKit
import Combine

class CastAndCrewCell: UICollectionViewCell, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    @Injected(\.imageLoader)
    private var imageLoaderService: ImageLoaderService
    private lazy var useCase: MovieUseCase = {
        return MovieUseCase(imageLoaderService: imageLoaderService)
    }()
    
    lazy var castAndCrewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var characterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    }
    
    func setup() {
        addSubviews()
        applyConstraints()
    }
    
    func applyStyles() {
        self.addShadowLayer()
        configuration.movies.design.style.castAndCrewImageViewStyle.apply(to: castAndCrewImageView)
        configuration.movies.design.style.castAndCrewNameLabelStyle.apply(to: nameLabel)
        configuration.movies.design.style.castAndCrewCharacterLabelStyle.apply(to: characterLabel)
    }
    
    func addSubviews() {
        addSubview(castAndCrewImageView)
        addSubview(vStackView)
        
        vStackView.addArrangedSubview(nameLabel)
        vStackView.addArrangedSubview(characterLabel)
    }
    
    func applyConstraints() {
        let constraints = [
            castAndCrewImageView.topAnchor.constraint(equalTo: topAnchor),
            castAndCrewImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            castAndCrewImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            castAndCrewImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystem.shared.sizers.md),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -DesignSystem.shared.sizers.md),
        ]
        addConstraints(constraints)
    }
    
    func setImageDTO(imageUrl: String?, name: String?, character: String?) {
        bag = useCase.loadImage(with: imageUrl).sink(receiveValue: { [weak self] image in
            let scaledImage = image?.scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 150)).withRoundedCorners(radius: 14)
            self?.castAndCrewImageView.image = scaledImage
        })
        nameLabel.text = name
        characterLabel.text = character
    }
}
