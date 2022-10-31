//
//  Created by Vijith on 22/10/2022.
//

import Foundation
import Combine
import CoreData

struct MovieViewModelInput {
    let selection: AnyPublisher<Movie, Never>
    let openSearch: AnyPublisher<[Movie], Never>
    let bookmark: AnyPublisher<(Int, Bool), Never>
}

enum MovieState {
    case idle
    case loading
    case movies([Movie])
    case staffPicks([Movie])
    case noResults
    case failure(Error)
}

extension MovieState: Equatable {
    static func == (lhs: MovieState, rhs: MovieState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.movies(let lhsMovies), .movies(let rhsMovies)): return lhsMovies == rhsMovies
        case (.staffPicks(let lhsStaffPicks), .staffPicks(let rhsStaffPicks)): return lhsStaffPicks == rhsStaffPicks
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias MovieViewModelOuput = AnyPublisher<MovieState, Never>

protocol MovieViewModelType {
    func transform(input: MovieViewModelInput) -> MovieViewModelOuput
}

final class MovieViewModel: MovieViewModelType {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    private var bag: [AnyCancellable] = []
    private weak var navigator: Navigator?
    private var useCase: MovieUseCase
    private var dbManager: DBManager = DBManager<MoviesEntity>()
    
    /// Get movies from movies JSON file
    private var movies: [Movie] {
        guard let data = Bundle.data(from: "movies") else {
            fatalError("No JSON file found")
        }
        let movies = try! JSONDecoder().decode([Movie].self, from: data)
        saveToDB(movies: movies)
        return movies
    }
    
    /// Get staff picks from JSON file
    private var staffPicks: [Movie] {
        guard let data = Bundle.data(from: "staff-picks") else {
            fatalError("No JSON file found")
        }
        let movies = try! JSONDecoder().decode([Movie].self, from: data)
        saveToDB(movies: movies)
        return movies
    }
    
    init(navigator: Navigator, useCase: MovieUseCase) {
        self.navigator = navigator
        self.useCase = useCase
    }
    
    /// Transform view input into output
    func transform(input: MovieViewModelInput) -> MovieViewModelOuput {
        bag.forEach { $0.cancel() }
        bag.removeAll()
        
        input.selection
            .sink { [unowned self] movie in self.bookmarkStatus(movie: movie) }
            .store(in: &bag)
        input.openSearch
            .sink { movies in self.navigator?.showSearch(movies) }
            .store(in: &bag)
        input.bookmark
            .sink { id, status in
                let predicate = NSPredicate(format: "movieId == %@", "\(id)")
                DBOperations.shared.updateBookmark(with: predicate, status: status)
            }.store(in: &bag)
        let staffPicks: MovieViewModelOuput = .just(.staffPicks(staffPicks))
        let movies: MovieViewModelOuput = .just(.movies(movies))
        return Publishers.Merge(movies, staffPicks).eraseToAnyPublisher()
    }
    
    func saveToDB(movies: [Movie]) {
        movies.forEach { movie in
            guard let id = movie.id else { return }
            dbManager.store { entity in
                entity.movie = movie
                entity.movieId = "\(id)"
                entity.bookmark = false
            }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("an error occurred \(error.localizedDescription)")
                case .finished:
                    debugPrint("PRINT VALUE \(completion)")
                }
            } receiveValue: { movies in
                debugPrint("SUCCESSFULLY SAVED")
            }.store(in: &bag)
        }
    }
    
    func bookmarkStatus(movie: Movie) {
        let predicate = NSPredicate(format: "movieId == %@", "\(movie.id ?? 0)")
        DBOperations.shared.fecthBookmarkFromDB(with: predicate) { status in
            self.navigator?.showDetails(movie, bookmarkStatus: status)
        }
    }
}
