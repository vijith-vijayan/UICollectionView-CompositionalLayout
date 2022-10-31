
//
//  Created by Vijith TV on 25/10/22.
//

import UIKit

public enum StarRounding: Int {
    case roundToHalfStar = 0
    case ceilToHalfStar = 1
    case floorToHalfStar = 2
    case roundToFullStar = 3
    case ceilToFullStar = 4
    case floorToFullStar = 5
}

class StarRatingView: UIView {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    var rating: Float = 3.5 {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    var starColor: (UIColor, UIColor) = (UIColor.systemOrange, UIColor.systemYellow) {
        didSet {
            for (index, item) in [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView].enumerated() {
                if index <= (Int(rating) - 1) {
                    item?.tintColor = starColor.0
                } else {
                    item?.tintColor = starColor.1
                }
                
            }
        }
    }
    
    var starRounding: StarRounding = .roundToHalfStar {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    
    var starRoundingRawValue:Int {
        get {
            return self.starRounding.rawValue
        }
        set {
            self.starRounding = StarRounding(rawValue: newValue) ?? .roundToHalfStar
        }
    }
    
    var size: CGSize = .zero {
        didSet {
            updateStackViewSize(with: size)
        }
    }
    
    var spacing: CGFloat = 0.0 {
        didSet {
            hstack?.spacing = spacing
        }
    }
    
    fileprivate var hstack: StarRatingStackView?

    private lazy var fullStarImage: UIImage = configuration.movies.design.starFillIcon!
    private lazy var halfStarImage: UIImage = UIImage(systemName: "star.lefthalf.fill")!
    private lazy var emptyStarImage: UIImage = configuration.movies.design.starFillIcon!

    var starCount: Int = 0 {
        didSet {
            hstack?.showStar(with: starCount)
        }
    }
    
    convenience init(frame: CGRect, rating: Float, color: UIColor, starRounding: StarRounding) {
        self.init(frame: frame)
        self.setupView(rating: rating, starRounding: starRounding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(rating: self.rating, starRounding: self.starRounding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView(rating: 3.5, starRounding: .roundToHalfStar)
    }
    
    
    fileprivate func setupView(rating: Float, starRounding: StarRounding) {
        let bundle = Bundle(for: StarRatingStackView.self)
        let nib = UINib(nibName: "StarRatingStackView", bundle: bundle)
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! StarRatingStackView
        self.addSubview(viewFromNib)
        
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            viewFromNib.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewFromNib.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewFromNib.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        addConstraints(constraints)
        
        self.hstack = viewFromNib
        self.rating = rating
        self.starRounding = starRounding
        
        self.isMultipleTouchEnabled = false
        self.hstack?.isUserInteractionEnabled = false
    }
    
    private func updateStackViewSize(with size: CGSize) {
        hstack?.heightConstraint.constant = size.height
        hstack?.widthConstraint.constant = size.width
    }
    
    fileprivate func setStarsFor(rating: Float) {
        let starImageViews = [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView]
        for i in 1...5 {
            let iFloat = Float(i)
            switch starRounding {
            case .roundToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat-0.25 ? fullStarImage :
                                            (rating >= iFloat-0.75 ? halfStarImage : emptyStarImage)
            case .ceilToHalfStar:
                starImageViews[i-1]!.image = rating > iFloat-0.5 ? fullStarImage :
                                            (rating > iFloat-1 ? halfStarImage : emptyStarImage)
            case .floorToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat ? fullStarImage :
                                            (rating >= iFloat-0.5 ? halfStarImage : emptyStarImage)
            case .roundToFullStar:
                starImageViews[i-1]!.image = rating >= iFloat-0.5 ? fullStarImage : emptyStarImage
            case .ceilToFullStar:
                starImageViews[i-1]!.image = rating > iFloat-1 ? fullStarImage : emptyStarImage
            case .floorToFullStar:
                starImageViews[i-1]!.image = rating >= iFloat ? fullStarImage : emptyStarImage
            }
        }
    }
}
