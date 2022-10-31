//
//  Created by Vijith TV on 28/10/22.
//

import UIKit

class GenreCell: UICollectionViewCell, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var genereLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        configuration.movies.design.style.genereCollectionViewConatinerStyle.apply(to: containerView)
        configuration.movies.design.style.genereLabelStyle.apply(to: genereLabel)
    }
    
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(genereLabel)
    }
    
    func applyConstraints() {
        let constriants = [
        
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            genereLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                 constant: DesignSystem.shared.sizers.sm),
            genereLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                  constant: -DesignSystem.shared.sizers.sm),
            genereLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ]
        addConstraints(constriants)
    }
    
    func setupGenre(_ genre: String?) {
        genereLabel.text = genre
    }
}
