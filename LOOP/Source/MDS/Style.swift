//
//  Created by Vijith on 20/10/2022.
//

import Foundation
import UIKit


/// An abstraction if `UIView` styling.
struct Style<T: UIView> {
    
    /// The styling function that takes a `UIView` instance
    /// and performs side-effects on it.
    let styling: (T)-> Void
    
    /// A factory method that composes multiple styles.
    ///
    /// - Parameter styles: The styles to compose.
    /// - Returns: A new `Style` that will call the input styles'
    ///            `styling` method in succession.
    static func compose(_ styles: Style<T>...)-> Style<T> {
        
        return Style { view in
            for style in styles {
                style.styling(view)
            }
        }
    }
    
    /// Compose this style with another.
    ///
    /// - Parameter other: Other style to compose this style with.
    /// - Returns: A new `Style` which will call this style's `styling`,
    ///            and then the `other` style's `styling`.
    func composing(with other: Style<T>)-> Style<T> {
        return Style { view in
            self.styling(view)
            other.styling(view)
        }
    }
    
    /// Compose this style with another styling function.
    ///
    /// - Parameter otherStyling: The function to compose this style with.
    /// - Returns: A new `Style` which will call this style's `styling`,
    ///            and then the input `styling`.
    func composing(with otherStyling: @escaping (T)-> Void)-> Style<T> {
        return self.composing(with: Style(styling: otherStyling))
    }
    
    
    /// Apply this style to a UIView.
    ///
    /// - Parameter view: the view to style
    func apply(to view: T) {
        styling(view)
    }
    
    
    /// Apply this style to multiple views.
    ///
    /// - Parameter views: the views to style
    func apply(to views: T...) {
        for view in views {
            styling(view)
        }
    }
}
