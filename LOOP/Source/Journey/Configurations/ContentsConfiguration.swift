//
//  Created by Vijith on 20/10/2022.
//

import Foundation

public extension Contents {
    
    /// Top level configuration for `Contents` journey
    struct Configuration {
        
        /// Initialiser for `Contents.Configuration`
        public init() { /* level empty */ }
        
        /// `LiveChat` screen configuration
        public var movies = Movies.Configuration()
    }
}
