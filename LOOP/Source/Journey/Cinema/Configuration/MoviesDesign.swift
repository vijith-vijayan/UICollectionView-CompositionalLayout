//
//  Created by Vijith on 20/10/2022.
//

import UIKit

public extension Movies {
    
    /// Configuration of styles used in `Movies` screen
    struct Design {
        
        /// Configuration of styles used in cinema screen
        public var style = Styles()
        
        /// Back button black icon shown in the details page
        public var leftArrowBlackIcon = UIImage(named: "left-arrow-black", in: .contents, with: nil)
        
        /// Back button black icon shown in the search page
        public var leftArrowWhiteIcon = UIImage(named: "left-arrow-white", in: .contents, with: nil)
        
        /// Search icon shown in the movies page
        public var searchIcon = UIImage(named: "search", in: .contents, with: nil)
        
        /// Favourite button unselected icon
        public var favouriteHollowIcon = UIImage(named: "favourite-hollow", in: .contents, with: nil)
        
        /// Favourite button selected icon
        public var favouriteFilledIcon = UIImage(named: "favourite-filled", in: .contents, with: nil)
        
        /// See all right arrow icon
        public var rightArrowIcon = UIImage(named: "right-arrow", in: .contents, with: nil)
        
        /// Star fill icon to showing rating
        public var starFillIcon = UIImage(named: "star-fill", in: .contents, with: nil)
        
        /// Star hollow icon to show unrating
        public var starHollowIcon = UIImage(named: "star-hollow", in: .contents, with: nil)
        
        /// Star white icon
        public var starWhiteIcon = UIImage(named: "star-white", in: .contents, with: nil)
        
        /// Close button icon
        public var closeIcon = UIImage(named: "close", in: .contents, with: nil)
        
        /// Bookmark black icon
        public var bookmarkBlackIcon = UIImage(named: "bookmark-black", in: .contents, with: nil)
        
        /// Search empty result
        public var seachEmptyIcon = UIImage(named: "empty-movie", in: .contents, with: nil)
    }
}
