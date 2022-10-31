//
//  Created by Vijith TV on 26/08/22.
//

import Foundation
import UIKit

//MARK: - REUSABLE
protocol ReuseIdentifying: AnyObject {
    
    /* RESUE IDENTIFIER */
    static var reuseIdentifier: String { get }
}

//MARK: - REUSABLE EXTENSION
extension ReuseIdentifying {
    
    /* RESUE IDENTIFIER DEFAULT IMPLEMENTATION */
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

//MARK: - EXTENSION OF VIEW FOR REUSABLE VIEW

extension UIView: ReuseIdentifying {}
extension ReuseIdentifying where Self: UIView {
    
    /* NIB FILE */
    func nib<T: UIView>(_ type: T.Type, bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: type.reuseIdentifier, bundle: bundle)
    }
}

//MARK: - EXTENSION OF REUSEABLE FOR COLLECTIONVIEW

extension ReuseIdentifying where Self: UICollectionView {
    
    /* REGISTER CELL FOR COLLECTIONVIEW */
    func registerCell<T: UICollectionViewCell>(of type: T.Type, bundle: Bundle? = nil) {
        register(T.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }
    
    /* REGISTER CELL SUPPLEMENTRY VIEW */
    func registerSupplementaryView<T: UICollectionReusableView>(of type: T.Type, with kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    /* DEQUEUE WITH REUSEABLE CELL */
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            return T()
        }
    }
    
    /* DEQUEUE WITH REUSEABLE SUPPLEMENTRY VIEW */
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, kind: String, for indexPath: IndexPath) -> T {
        if let supplementryView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T {
            return supplementryView
        } else {
            return T()
        }
    }
}

//MARK: - EXTENSION OF REUSEABLE FOR UIVIEWCONRTOLLER
extension UIViewController: ReuseIdentifying {}
extension ReuseIdentifying where Self: UIViewController {
    
    /* LOAD XIB FILE */
    static func loadXib(from bundle: Bundle?) -> Self {
        return Self(nibName: Self.reuseIdentifier, bundle: bundle)
    }
    
}
