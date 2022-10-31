//
//  Created by Vijith on 21/10/2022.
//

import UIKit

public class SectionHeader: UICollectionReusableView, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = AccessibilityIdentifiers.SectionHeader.titleLabelId
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(configuration.movies.design.searchIcon, for: .normal)
        button.addTarget(self, action: #selector(searchPressed(_:)), for: .touchUpInside)
        button.accessibilityIdentifier = AccessibilityIdentifiers.SectionHeader.searchButtonId
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var buttonWidthConstraint: NSLayoutConstraint?
    private var buttonHeightConstriant: NSLayoutConstraint?
    private var titleTopConstraint: NSLayoutConstraint?
    private var titleLeadingConstraint: NSLayoutConstraint?
    private var buttonTopConstraint: NSLayoutConstraint?
    
    static let reuseIdentifier = "sectionHeader"
    
    var title: String = "" {
        didSet {
            let mappedTitle = configuration.movies.uiDataMapper.headerTitleProvider(title)
            titleLabel.attributedText = mappedTitle
        }
    }
    var sectionConfig: Section? {
        didSet {
            switch sectionConfig {
            case .movies(_):
                title = "YOUR FAVOURITES"
                titleLabel.textColor = DesignSystem.shared.colors.backgroundColor
            case .staffPicks(_):
                title = "OUR STAFF PICKS"
                titleLabel.textColor = .white
                titleLeadingConstraint?.constant = DesignSystem.shared.sizers.xl
                titleTopConstraint?.constant = 40
                searchButton.isHidden = true
            case .none:
                break
            }
            layoutIfNeeded()
        }
    }
    var didPressSearch: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        applyStyles()
    }
    
     func setup() {
        addSubviews()
        applyConstraints()
    }
    
    func addSubviews() {
        addSubview(searchButton)
        addSubview(titleLabel)
    }
    
    func applyStyles() {
        configuration.movies.design.style.searchButtonStyle.apply(to: searchButton)
    }
    
    func applyConstraints() {
        buttonHeightConstriant = searchButton.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 1.6)
        buttonWidthConstraint = searchButton.widthAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 1.6)
        buttonTopConstraint = searchButton.topAnchor.constraint(equalTo: topAnchor, constant: DesignSystem.shared.sizers.xl * 2)
        
        let titleTopConstant = (buttonTopConstraint?.constant ?? 0.00) + (buttonHeightConstriant?.constant ?? 0.00) + DesignSystem.shared.sizers.xl * 1.66
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: titleTopConstant)
        titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        let constraints = [
            
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonTopConstraint,
            buttonWidthConstraint,
            buttonHeightConstriant,
            
            titleLeadingConstraint,
            titleTopConstraint,
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        addConstraints(constraints.compactMap { $0 })
    }
    
    func updateConstraint() {
        buttonTopConstraint?.constant = 0
        buttonWidthConstraint?.constant = 0
        buttonHeightConstriant?.constant = 0
        titleTopConstraint?.constant = 0
    }
    
    @objc
    func searchPressed(_ sender: UIButton) {
        didPressSearch?()
    }
}
