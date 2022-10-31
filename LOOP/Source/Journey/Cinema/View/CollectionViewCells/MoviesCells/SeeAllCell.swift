//
//  SeeAllCell.swift
//  LOOP
//
//  Created by Vijith TV on 24/10/22.
//

import UIKit

class SeeAllCell: UICollectionViewCell {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    lazy var seeAllView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var seeAllLabel: UILabel = {
        let label = UILabel()
        label.text = "See all"
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = configuration.movies.design.rightArrowIcon
        imgView.contentMode = .scaleAspectFit
        return imgView
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
        
        applyStyle()
    }
    
    private func setup() {
        addSubView()
        applyConstraints()
    }
    
    private func applyStyle() {
        configuration.movies.design.style.seeAllViewStyle.apply(to: seeAllView)
        configuration.movies.design.style.seeAllLabelStyle.apply(to: seeAllLabel)
    }
    
    private func addSubView() {
        addSubview(seeAllView)
        addSubview(hStackView)
        
        hStackView.addArrangedSubview(seeAllLabel)
        hStackView.addArrangedSubview(imageView)
        hStackView.setCustomSpacing(06, after: imageView)
    }
    
    private func applyConstraints() {
        let constraints = [
            seeAllView.widthAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 3),
            seeAllView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl),
            seeAllView.centerXAnchor.constraint(equalTo: centerXAnchor),
            seeAllView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            hStackView.topAnchor.constraint(equalTo: seeAllView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: seeAllView.leadingAnchor, constant: DesignSystem.shared.sizers.sm * 1.5),
            hStackView.trailingAnchor.constraint(equalTo: seeAllView.trailingAnchor, constant: -DesignSystem.shared.sizers.sm * 1.5),
            hStackView.bottomAnchor.constraint(equalTo: seeAllView.bottomAnchor)
        ]
        addConstraints(constraints)
    }
}
