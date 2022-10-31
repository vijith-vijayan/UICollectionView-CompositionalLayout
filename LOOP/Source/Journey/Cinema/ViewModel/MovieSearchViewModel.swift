//
//  Created by Vijith on 24/10/2022.
//


import Foundation
import Combine
import CoreData

// INPUT
struct MovieSearchViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let search: AnyPublisher<(String, SearchType), Never>
    let selection: AnyPublisher<Movie, Never>
    let hasEnded: AnyPublisher<Void, Never>
    let backPressed: AnyPublisher<Void, Never>
    let bookmark: AnyPublisher<(Int, Bool), Never>
}

// OUTPUT
enum MovieSearchState {
    case loading
    case success([Movie])
    case failure(Error)
    case noResults
    case appear([Movie])
}

extension MovieSearchState: Equatable {
    static func == (lhs: MovieSearchState, rhs: MovieSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsMovie), .success(let rhsMovie)): return lhsMovie == rhsMovie
        case (.failure, .failure): return true
        case (.noResults, .noResults): return true
        case (.appear(let lhsMovie), .appear(let rhsMovie)): return lhsMovie == rhsMovie
        default: return false
        }
    }
}

typealias MovieSearchViewModelOutput = AnyPublisher<MovieSearchState, Never>

protocol MovieSearchViewModelType: AnyObject {
    func transform(input: MovieSearchViewModelInput) -> MovieSearchViewModelOutput
}


class MovieSearchViewModel: MovieSearchViewModelType {
    
    private let movies: [Movie]
    private let useCase: MovieUseCase
    private let navigator: Navigator
    private var bag: [AnyCancellable] = []
    private let dbManager: DBManager = DBManager<MoviesEntity>()
    
    init(movies: [Movie], useCase: MovieUseCase, navigator: Navigator) {
        self.movies = movies
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: MovieSearchViewModelInput) -> MovieSearchViewModelOutput {
        
        let appear: MovieSearchViewModelOutput = .just(.appear(self.movies))
        let search = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
        let movies = search
            .flatMapLatest { [unowned self] query, type in
                searchMovie(with: query, type: type)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
        let output: MovieSearchViewModelOutput = Publishers.Merge(appear, movies).eraseToAnyPublisher()
        let hasEnded = input.hasEnded
            .flatMapLatest { [unowned self] _ in
                searchEndedWithEmptyString()
            }
            .map { result -> MovieSearchState in
                switch result {
                case .success(let movies): return .success(movies)
                default: return .noResults
                }
            }.eraseToAnyPublisher()
        input.backPressed
            .sink { [unowned self] _ in self.navigator.popViewController() }
            .store(in: &bag)
        input.bookmark
            .sink { id, status in
                let predicate = NSPredicate(format: "movieId == %@", "\(id)")
                DBOperations.shared.updateBookmark(with: predicate, status: status)
            }.store(in: &bag)
        return Publishers.Merge(output, hasEnded).eraseToAnyPublisher()
        
    }
    
    private func searchMovie(with query: String, type: SearchType) -> AnyPublisher<MovieSearchState, Never> {
        let result = movies.filter {
            switch type {
            case .query:
                return ($0.title?.range(of: query, options: .caseInsensitive)) != nil
            case .rating:
                guard let rating = Double(query), let value = $0.rating else { return false }
                return value.rounded() == rating ? true : false
            }
        }
        if result.isEmpty {
            return Deferred { return Just(.noResults)}.eraseToAnyPublisher()
        }
        return Deferred { return Just(.success(result))}.eraseToAnyPublisher()
    }
    
    private func searchEndedWithEmptyString() -> AnyPublisher<MovieSearchState, Never> {
        return Deferred { return Just(.success(self.movies))}.eraseToAnyPublisher()
    }
}

enum SearchType {
    case query
    case rating
}
