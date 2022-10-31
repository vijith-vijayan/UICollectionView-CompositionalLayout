//
//  Created by Vijith TV on 26/10/22.
//

import UIKit

class GradientView: UIView {

    // Default Colors
    var colors: [UIColor] = [
        DesignSystem.shared.colors.backgroundColor,
        DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0)
    ]

    override func draw(_ rect: CGRect) {

        // Must be set when the rect is drawn
        setGradient(color1: colors[0], color2: colors[1])
    }

    func setGradient(color1: UIColor, color2: UIColor) {

        let context = UIGraphicsGetCurrentContext()
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [color1.cgColor, color2.cgColor] as CFArray, locations: [0, 1])!

        // Draw Path
        let path = UIBezierPath(rect: CGRectMake(0, 0, frame.width, frame.height))
        context?.saveGState()
        path.addClip()
        context?.drawLinearGradient(gradient, start: CGPointMake(frame.width / 2, 0), end: CGPointMake(frame.width / 2, frame.height), options: CGGradientDrawingOptions())
        context?.restoreGState()
    }

    override func layoutSubviews() {
        // Ensure view has a transparent background color (not required)
        backgroundColor = UIColor.clear
    }

}
