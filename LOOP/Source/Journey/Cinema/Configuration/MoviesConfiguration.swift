//
//  Created by Vijith on 20/10/2022.
//

import Foundation

public extension Movies {
    
    /// Top level configuration for `Content` Journey
    struct Configuration {
        
        /// Initialiser for `Content.Configuration`
        public init() { /* level empty */ }
        
        /// Configuration of styles used in Movies screen
        public var design = Design()
        
        /// Router configuration for Movies screen
        public var router = Router()
        
        /// UIDataMapper configuration for Movies screen
        public var uiDataMapper = UIDataMapper()
    }
}
