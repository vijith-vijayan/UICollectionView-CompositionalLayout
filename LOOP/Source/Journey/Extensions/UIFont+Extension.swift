//
//  Created by Vijith on 21/10/2022.
//

import UIKit

public extension UIFont {
    static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        return UIFont.preferredFont(forTextStyle: style, weight: weight, contentSizeCategory: .unspecified)
    }

    static func preferredFont(forTextStyle style: TextStyle,
                              weight: Weight,
                              contentSizeCategory: UIContentSizeCategory) -> UIFont {
        return UIFont.preferredFont(
            forTextStyle: style,
            weight: weight,
            contentSizeCategory: contentSizeCategory,
            fontName: nil
        )
    }

    static func preferredFont(forTextStyle style: TextStyle,
                              weight: Weight,
                              contentSizeCategory: UIContentSizeCategory,
                              fontName: String?) -> UIFont {
        
        let sizingTraits = UITraitCollection.init(preferredContentSizeCategory: contentSizeCategory)
        let sizingDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: sizingTraits)

        if let fontName = fontName,
           let font = UIFont.init(name: fontName, size: sizingDescriptor.pointSize) {
            var attributes = font.fontDescriptor.fontAttributes
            var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
            traits[.weight] = weight
            attributes[.traits] = traits
            let descriptor = UIFontDescriptor(fontAttributes: attributes)
            return UIFont(descriptor: descriptor, size: descriptor.pointSize)
        }
        
        return UIFont.systemFont(ofSize: sizingDescriptor.pointSize, weight: weight)
    }
}
