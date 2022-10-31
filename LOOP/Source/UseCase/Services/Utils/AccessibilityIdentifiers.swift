//
//  Created by Vijith on 20/10/2022.
//

import Foundation

public struct AccessibilityIdentifiers {
    
    public struct Movies {
        public static let rootViewId = "\(Movies.self).rootViewId"
        public static let collectionViewId = "\(Movies.self).collectionViewId"
        public static let slantedViewId = "\(Movies.self).slanteViewId"
    }
    
    public struct SectionHeader {
        public static let rootViewId = "\(SectionHeader.self).rootViewId"
        public static let searchButtonId = "\(SectionHeader.self).searchButtonId"
        public static let titleLabelId = "\(SectionHeader.self).titleLabelId"
    }
    
    public struct FavouritesCell {
        public static let rootViewId = "\(FavouritesCell.self).rootViewId"
        public static let posterImageViewId = "\(FavouritesCell.self).posterImageViewId"
    }
    
    public struct MovieDetails {
        public static let rootViewId = "\(MovieDetails.self).rootViewId"
        public static let contentViewId = "\(MovieDetails.self).contentViewId"
        public static let titleLabelId = "\(MovieDetails.self).titleLabelId"
        public static let subtitleLabelId = "\(MovieDetails.self).subtitleLabelId"
        public static let descriptionLabelId = "\(MovieDetails.self).descriptionLabelId"
        public static let loadingIndicatorId = "\(MovieDetails.self).loadingIndicatorId"
    }
}
