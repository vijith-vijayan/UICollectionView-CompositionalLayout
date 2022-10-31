//
//  StarRatingStackView.swift
//
//  Created by Guido on 7/1/20.
//  Copyright © applified.life - All rights reserved.
//

import UIKit

class StarRatingStackView: UIStackView {
    
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func showStar(with count: Int) {
        switch count {
        case 1:
            star1ImageView.isHidden = false
            star2ImageView.isHidden = true
            star3ImageView.isHidden = true
            star4ImageView.isHidden = true
            star5ImageView.isHidden = true
        case 2:
            star1ImageView.isHidden = false
            star2ImageView.isHidden = false
            star3ImageView.isHidden = true
            star4ImageView.isHidden = true
            star5ImageView.isHidden = true
        case 3:
            star1ImageView.isHidden = false
            star2ImageView.isHidden = false
            star3ImageView.isHidden = false
            star4ImageView.isHidden = true
            star5ImageView.isHidden = true
        case 4:
            star1ImageView.isHidden = false
            star2ImageView.isHidden = false
            star3ImageView.isHidden = false
            star4ImageView.isHidden = false
            star5ImageView.isHidden = true
        case 5:
            star1ImageView.isHidden = false
            star2ImageView.isHidden = false
            star3ImageView.isHidden = false
            star4ImageView.isHidden = false
            star5ImageView.isHidden = false
        default:
            break
        }
    }

}
