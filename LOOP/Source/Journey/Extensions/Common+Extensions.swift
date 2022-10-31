//
//  Created by Vijith on 22/10/2022.
//

import UIKit

public extension UIView {
    
    func addShadowLayer() {
        layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 15.0
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

extension UIImage {
    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
    
    // image with rounded corners
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func addShadow(blurSize: CGFloat = 4.0) -> UIImage {
        
        let shadowColor = UIColor(white:0.0, alpha:0.2).cgColor
        
        let context = CGContext(data: nil,
                                width: Int(self.size.width + blurSize),
                                height: Int(self.size.height + blurSize),
                                bitsPerComponent: self.cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        context.setShadow(offset: CGSize(width: blurSize/2, height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        context.draw(self.cgImage!,
                     in: CGRect(x: 0, y: blurSize, width: self.size.width, height: self.size.height),
                     byTiling:false)
        
        return UIImage(cgImage: context.makeImage()!)
    }
}

extension Sequence {
    func limit(_ max: Int) -> [Element] {
        return self.enumerated()
            .filter { $0.offset < max }
            .map { $0.element }
    }
}

extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String, with image: UIImage) {
        
        let holderView = UIView()
        holderView.backgroundColor = .clear
        backgroundView = holderView
        holderView.translatesAutoresizingMaskIntoConstraints = true

        holderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        holderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        holderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        holderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let vStackView = UIStackView()
        vStackView.alignment = .center
        vStackView.distribution = .fill
        vStackView.axis = .vertical
        vStackView.spacing = DesignSystem.shared.sizers.xl
        vStackView.translatesAutoresizingMaskIntoConstraints  = false
        holderView.addSubview(vStackView)
        
        vStackView.centerXAnchor.constraint(equalTo: holderView.centerXAnchor).isActive = true
        vStackView.centerYAnchor.constraint(equalTo: holderView.centerYAnchor,
                                            constant: -DesignSystem.shared.sizers.xl * 1.5).isActive = true
        
        
        let imageView = UIImageView(image: image)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = DesignSystem.shared.colors.white60
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = DesignSystem.shared.font.preferredFont(.callout, .bold)
        messageLabel.sizeToFit()
        
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(messageLabel)
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}
