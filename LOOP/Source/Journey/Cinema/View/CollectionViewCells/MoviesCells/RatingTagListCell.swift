//
//  RatingTagListCell.swift
//  LOOP
//
//  Created by Vijith TV on 26/10/22.
//

import UIKit

class RatingTagListCell: UICollectionViewCell, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var starView: StarRatingView = {
        let starView = StarRatingView()
        starView.starRounding = .roundToFullStar
        starView.size = CGSize(width: DesignSystem.shared.sizers.sm + 2, height: DesignSystem.shared.sizers.sm + 1)
        starView.spacing = 2
        starView.isUserInteractionEnabled = false
        starView.translatesAutoresizingMaskIntoConstraints = false
        return starView
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
        addSubview(containerView)
        containerView.addSubview(starView)
    }
    
    func applyStyles() {
        configuration.movies.design.style.ratingListViewStyle.apply(to: containerView)
    }
    
    func applyConstraints() {
        let constraint = [
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            starView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DesignSystem.shared.sizers.md),
            starView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.sm * 1.5),
            starView.centerYAnchor.constraint(equalTo: centerYAnchor),
            starView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DesignSystem.shared.sizers.md)
        ]
        addConstraints(constraint)
    }
    
    func setCount(_ count: Int) {
        starView.rating = Float(count)
        starView.starCount = count
        starView.starColor = (.white, .white)
    }
    
    func update(_ selected: Bool) {
        if selected {
            starView.starColor = (DesignSystem.shared.colors.gold, DesignSystem.shared.colors.gold)
        } else {
            starView.starColor = (.white, .white)
        }
    }
}
