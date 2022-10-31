//
//  Created by Vijith on 22/10/2022.
//

import UIKit
import Combine

public struct MovieUseCase: ContentsUseCase {
    
    private let imageLoaderService: ImageLoaderServiceType

    init(imageLoaderService: ImageLoaderServiceType) {
        self.imageLoaderService = imageLoaderService
    }
    
    /// Load Image from Movie
    /// - Parameters: Movie object
    /// - Returns: Anypublisher object
    func loadImage(for movie: Movie) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(movie.posterURL) }
        .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
            guard let poster = movie.posterURL else { return .just(nil) }
            guard let url = URL(string: poster) else { return .just(nil)}
            return self.imageLoaderService.loadImage(from: url)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }
    
    /// Load Image from URL
    /// - Parameters: Movie object
    /// - Returns: Anypublisher object
    func loadImage(with uRL: String?) -> AnyPublisher<UIImage?, Never> {
        return Deferred { return Just(uRL) }
        .flatMap({ poster -> AnyPublisher<UIImage?, Never> in
            guard let poster = uRL else { return .just(nil) }
            guard let url = URL(string: poster) else { return .just(nil)}
            return self.imageLoaderService.loadImage(from: url)
        })
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .share()
        .eraseToAnyPublisher()
    }
}
