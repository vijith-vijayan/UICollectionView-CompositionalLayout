//
//  Created by Vijith TV on 30/10/22.
//

import UIKit

class OverviewCell: UICollectionViewCell, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    private lazy var overviewLabel: UILabel = {
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
    
    func setup() {
        addSubviews()
        applyStyles()
        applyConstraints()
    }
    
    func applyStyles() {
        configuration.movies.design.style.overviewLabelStyle.apply(to: overviewLabel)
    }
    
    func addSubviews() {
        addSubview(overviewLabel)
    }
    
    func applyConstraints() {
        let constrainsts = [
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            overviewLabel.topAnchor.constraint(equalTo: topAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignSystem.shared.sizers.lg),
            overviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        addConstraints(constrainsts)
    }
    
    
    func setupOverviewDTO(overview: String?) {
        overviewLabel.text = overview
    }
}
