//
//  Created by Vijith on 20/10/2022.
//

import Foundation

public extension Bundle {
    
    /// Bundle object for contents
    static var contents: Bundle? {
        let bundle = Bundle(for: ContentsBundleToken.self)
        guard let resourceUrl = bundle.url(forResource: "Assets", withExtension: "bundle") else {
            return bundle
        }
        guard let resourceBundle = Bundle(url: resourceUrl) else { return bundle }
        return resourceBundle
    }
    
    /// Json to data object
    static func data(from fileName: String) -> Data? {
        let bundle = Bundle(for: ContentsBundleToken.self)
        guard
            let url = bundle.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }
}
