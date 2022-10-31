//
//  Created by Vijith TV on 25/10/22.
//

import Foundation

class ServicesProvider {
    let imageLoader: ImageLoaderServiceType

    static func defaultProvider() -> ServicesProvider {
        let imageLoader = ImageLoaderService()
        return ServicesProvider(imageLoader: imageLoader)
    }

    init(imageLoader: ImageLoaderServiceType) {
        self.imageLoader = imageLoader
    }
}
