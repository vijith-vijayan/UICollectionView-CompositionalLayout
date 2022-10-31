//
//  Created by Vijith TV on 30/10/22.
//

import UIKit

class KeyFactsCell: UICollectionViewCell, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var keyFactsTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var keyFactsValue: UILabel = {
        let label = UILabel()
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
    
    func addSubviews() {
        addSubview(vStackView)
        vStackView.addArrangedSubview(keyFactsTitle)
        vStackView.addArrangedSubview(keyFactsValue)
    }
    
    func applyStyles() {
        configuration.movies.design.style.keyFactsViewStyle.apply(to: self)
        configuration.movies.design.style.keyFactsTitleLabelStyle.apply(to: keyFactsTitle)
        configuration.movies.design.style.keyFactsValueLabelStyle.apply(to: keyFactsValue)
    }
    
    func applyConstraints() {
        let constraints = [
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: DesignSystem.shared.sizers.sm * 1.5),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DesignSystem.shared.sizers.sm * 1.5),
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystem.shared.sizers.md),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignSystem.shared.sizers.md)
        ]
        addConstraints(constraints)
    }
    
    func setupDTO(title: String, value: String) {
        keyFactsTitle.text = title
        keyFactsValue.text = value
    }
}
