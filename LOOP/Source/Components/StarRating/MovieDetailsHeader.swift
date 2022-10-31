//
//  Created by Vijith TV on 30/10/22.
//

import UIKit

class MovieDetailsHeader: UICollectionReusableView, ViewSetupProvidable {
        
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    private lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var headerTitle: String = "" {
        didSet {
            headerTitleLabel.text = headerTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubviews()
        applyStyles()
        applyConstraints()
    }
    
    func addSubviews() {
        addSubview(headerTitleLabel)
    }
    
    func applyStyles() {
        configuration.movies.design.style.detailSectionTitleLabelStyle.apply(to: headerTitleLabel)
    }
    
    func applyConstraints() {
        let constraints = [
            headerTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: DesignSystem.shared.sizers.xl)
        ]
        addConstraints(constraints)
    }
}
