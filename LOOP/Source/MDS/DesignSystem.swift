//
//  Created by Vijith on 20/10/2022.
//

import UIKit

class DesignSystem {
    
    static let shared = DesignSystem()
    
    private init () { }
    
    var cornerRadius = DesignSystem.CornerRadius()
    var font = DesignSystem.Fonts()
    var sizers = DesignSystem.Sizers()
    var colors = DesignSystem.Colors()
}

extension DesignSystem {
    
    struct CornerRadius {
        var small: CGFloat = 4
        var medium: CGFloat = 8
        var large: CGFloat = 16
    }
    
    struct Fonts {
        public init() {}
        
        /// returns preferred font for given text style and weight, following the current user setting for content size category
        public var preferredFont: (UIFont.TextStyle, UIFont.Weight) -> UIFont = { style, weight in
            return UIFont.preferredFont(forTextStyle: style, weight: weight, contentSizeCategory: .unspecified)
        }
    }
    
    struct Sizers {
        public var xxs: CGFloat = 2
        public var xs: CGFloat = 4
        public var sm: CGFloat = 8
        public var md: CGFloat = 16
        public var lg: CGFloat = 24
        public var xl: CGFloat = 30
    }
    
    struct Colors {
        
        public var backgroundColor = UIColor(named: "background-color", in: .contents, compatibleWith: .none) ?? .red
        public var searchBarBackgroundColor  = UIColor(named: "search-bar-background-color", in: .contents, compatibleWith: .none) ?? .red
        
        public var gold =  UIColor(named: "gold", in: .contents, compatibleWith: .none) ?? .red
        
        public var white40 = UIColor(named: "white40", in: .contents, compatibleWith: .none) ?? .red
        public var white60 = UIColor(named: "white60", in: .contents, compatibleWith: .none) ?? .red
        
        public var offWhite = UIColor(named: "offWhite", in: .contents, compatibleWith: .none) ?? .red
    }
}
