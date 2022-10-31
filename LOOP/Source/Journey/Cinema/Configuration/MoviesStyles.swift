//
//  Created by Vijith on 20/10/2022.
//

import UIKit

public extension Movies.Design {
    
    struct Styles {
        
        var backgroundViewLightStyle: Style<UIView> = Style {
            $0.backgroundColor = .white
        }
        
        var backgroundViewDarkStyle: Style<UIView> = Style {
            $0.backgroundColor = DesignSystem.shared.colors.backgroundColor
        }
        
        var searchButtonStyle: Style<UIButton> = Style {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.medium * 1.5
            $0.addShadowLayer()
        }
        
        var collectionViewStyle: Style<UICollectionView> = Style {
            $0.backgroundColor = .clear
        }
        
        var posterImageViewStyle: Style<UIImageView> = Style {
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.medium * 1.5
            $0.contentMode = .scaleAspectFit
            $0.layer.masksToBounds = true
        }
        
        var yearLabelStyle: Style<UILabel> = Style {
            $0.textColor = DesignSystem.shared.colors.white60
            $0.font = DesignSystem.shared.font.preferredFont(.caption1, .bold)
        }
        
        var movieLabelStyle: Style<UILabel> = Style {
            $0.textColor = .white
            $0.font = DesignSystem.shared.font.preferredFont(.body, .bold)
        }
        
        var seeAllViewStyle: Style<UIView> = Style {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.large
        }
        
        var seeAllLabelStyle: Style<UILabel> = Style {
            $0.textColor = DesignSystem.shared.colors.backgroundColor
            $0.font = DesignSystem.shared.font.preferredFont(.footnote, .heavy)
        }
        
        var searchBarViewStyle: Style<UIView> = Style {
            $0.backgroundColor = DesignSystem.shared.colors.searchBarBackgroundColor
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.medium * 1.5
            $0.layer.borderWidth = DesignSystem.shared.sizers.xxs / 2
            $0.layer.borderColor = UIColor.black.cgColor
            $0.addShadowLayer()
        }
        
        var searchTextFieldStyle: Style<UITextField> = Style {
            $0.textColor = .white
            $0.attributedPlaceholder = NSAttributedString(string: "Search all movies",
                                                          attributes: [.foregroundColor: DesignSystem.shared.colors.white40])
            $0.font = DesignSystem.shared.font.preferredFont(.callout, .bold)
        }
        
        var ratingListViewStyle: Style<UIView> = Style {
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.large
        }
        
        var dateAndTimeLabelStyle: Style<UILabel> = Style {
            $0.textColor = DesignSystem.shared.colors.white60
            $0.textAlignment = .center
            $0.font = DesignSystem.shared.font.preferredFont(.callout, .light)
        }
        
        var genereCollectionViewConatinerStyle: Style<UIView> = Style {
            $0.backgroundColor = DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0.1)
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.medium * 1.5
            $0.clipsToBounds = true
        }
        
        var genereLabelStyle: Style<UILabel> = Style {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = DesignSystem.shared.font.preferredFont(.footnote, .light)
        }
        
        var movieHeaderCellTitleLabelStyle: Style<UILabel> = Style {
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        var movieDetailsTitleLabelStyle: Style<UILabel> = Style {
            $0.textColor = .black
            $0.numberOfLines = 0
            $0.textAlignment = .left
            $0.font = DesignSystem.shared.font.preferredFont(.title3, .heavy)
        }
        
        var movieDurationLabelStyle: Style<UILabel> = Style {
            $0.textColor = .black.withAlphaComponent(0.6)
            $0.textAlignment = .center
            $0.font = DesignSystem.shared.font.preferredFont(.caption1, .light)
        }
        var tagListViewSearchStyle: Style<TagListView> = Style {
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
        }
        
        var tagListViewDetailsStyle: Style<TagListView> = Style {
            $0.backgroundColor = .clear
            $0.clipsToBounds = false
        }
        
        var castAndCrewImageViewStyle: Style<UIImageView> = Style {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.medium * 1.5
        }
        
        var castAndCrewNameLabelStyle: Style<UILabel> = Style {
            $0.textColor = .white
            $0.numberOfLines = 2
            $0.font = DesignSystem.shared.font.preferredFont(.caption1, .bold)
        }
        
        var castAndCrewCharacterLabelStyle: Style<UILabel> = Style {
            $0.textColor = .white.withAlphaComponent(0.6)
            $0.numberOfLines = 2
            $0.font = DesignSystem.shared.font.preferredFont(.caption1, .light)
        }
        
        var overviewLabelStyle: Style<UILabel> = Style {
            $0.numberOfLines = 0
            $0.textColor = DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0.7)
            $0.font = DesignSystem.shared.font.preferredFont(.callout, .light)
        }
        
        var keyFactsViewStyle: Style<UIView> = Style {
            $0.backgroundColor = DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0.1)
            $0.layer.cornerRadius = DesignSystem.shared.cornerRadius.large
        }
        
        var keyFactsTitleLabelStyle: Style<UILabel> = Style {
            $0.textColor = DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0.7)
            $0.font = DesignSystem.shared.font.preferredFont(.caption2, .bold)
        }
        
        var keyFactsValueLabelStyle: Style<UILabel> = Style {
            $0.textColor = DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0.7)
            $0.font = DesignSystem.shared.font.preferredFont(.callout, .light)
        }
        
        var detailSectionTitleLabelStyle: Style<UILabel> = Style {
            $0.textColor = DesignSystem.shared.colors.backgroundColor
            $0.font = DesignSystem.shared.font.preferredFont(.footnote, .bold)
        }
    }
}
