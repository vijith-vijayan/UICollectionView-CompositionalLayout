//
//  Created by Vijith TV on 28/10/22.
//

import Foundation
import Combine

struct MovieDetailsViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let bookmark: AnyPublisher<Bool, Never>
}

enum MovieDetailsState {
    case idle
    case movies(Movie)
    case bookmark(Bool)
    case failure(Error)
}

extension MovieDetailsState: Equatable {
    static func == (lhs: MovieDetailsState, rhs: MovieDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.movies(let lhsMovies), .movies(let rhsMovies)): return lhsMovies == rhsMovies
        case (.bookmark, .bookmark): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias MovieDetailsViewModelOutput = AnyPublisher<MovieDetailsState, Never>

protocol MovieDetailsViewModelType: AnyObject {
    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput
}

class MovieDetailsViewModel: MovieDetailsViewModelType {
    
    private var movie: Movie
    private var bookmarkStatus: Bool
    
    init(movie: Movie, bookmarkStatus: Bool) {
        self.movie = movie
        self.bookmarkStatus = bookmarkStatus
    }
    
    func transform(input: MovieDetailsViewModelInput) -> MovieDetailsViewModelOutput {
        let appear: MovieDetailsViewModelOutput = .just(.movies(self.movie))
        let bookmark: MovieDetailsViewModelOutput = .just(.bookmark(bookmarkStatus))
        return Publishers.Merge(appear, bookmark).eraseToAnyPublisher()
    }
}
