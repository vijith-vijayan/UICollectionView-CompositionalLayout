//
//  Created by Vijith on 22/10/2022.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoaderServiceType: AnyObject {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
