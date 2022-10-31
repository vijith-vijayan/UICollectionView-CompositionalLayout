//
//  Created by Vijith on 22/10/2022.
//

import UIKit
import Combine

protocol ContentsUseCase {

    // Loads image for the given movie
    func loadImage(for movie: Movie) -> AnyPublisher<UIImage?, Never>
}
