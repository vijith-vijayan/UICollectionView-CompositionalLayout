//
//  Created by Vijith on 20/10/2022.
//


import UIKit

class SlantedView: UIView {

    // MARK: - DEPENDENCY INJECTION
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    // MARK: - PROPERTIES
    
    /// Mask Layer
    private var maskLayer: CAShapeLayer?
    
    // MARK: - INITIALISER
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup(with: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP
    func setup(with maskRect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: maskRect.minX, y: maskRect.minY))
        path.addLine(to: CGPoint(x: maskRect.width, y: maskRect.minY))
        path.addLine(to: CGPoint(x: maskRect.width, y: maskRect.height * 0.8))
        path.addLine(to: CGPoint(x: maskRect.minX, y: maskRect.height))
        maskLayer = CAShapeLayer()
        layer.addSublayer(maskLayer!)
        maskLayer?.path = path.cgPath
        maskLayer?.fillColor = UIColor.white.cgColor
        applyStyles()
    }
    
    private func applyStyles() {
        configuration.movies.design.style.backgroundViewDarkStyle.apply(to: self)
    }
}
