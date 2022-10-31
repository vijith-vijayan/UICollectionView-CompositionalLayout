//
//  Created by Vijith on 20/10/2022.
//

import UIKit

public extension Movies {
    
    /// Movies Router
    struct Router {
    }
}

class RouterCoordinator: FlowCoordinator {
    
    fileprivate let window: UIWindow
    fileprivate var navigationController: UINavigationController?
    fileprivate let dependencyProvider: RouterDependencyProvider
    
    init(window: UIWindow, dependencyProvider: RouterDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let viewController = dependencyProvider.navigationController(navigator: self)
        window.rootViewController = viewController
        self.navigationController = viewController
    }
}

extension RouterCoordinator: Navigator {
    
    func showSearch(_ movies: [Movie]) {
        let controller = dependencyProvider.movieSearchViewController(movies: movies, navigator: self)
        navigationController?.pushViewController(controller, animated: false)
    }
    
    func showDetails(_ movie: Movie, bookmarkStatus: Bool) {
        let controller = dependencyProvider.moviesDetailsViewController(movie: movie, bookmarkStatus: bookmarkStatus)
        controller.modalPresentationStyle = .pageSheet
        navigationController?.present(controller, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

protocol RouterDependencyProvider: AnyObject {
    func navigationController(navigator: Navigator) -> UINavigationController
    func moviesDetailsViewController(movie: Movie, bookmarkStatus: Bool) -> UIViewController
    func movieSearchViewController(movies: [Movie], navigator: Navigator) -> UIViewController
}

protocol FlowCoordinator: AnyObject {
    func start()
}

protocol Navigator: AnyObject {
    func showSearch(_ movies: [Movie])
    func showDetails(_ movie: Movie, bookmarkStatus: Bool)
    func popViewController()
}

final class NavigationComponents: AppFlowCoordinatorDependencyProvider {
    
    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultProvider()) {
        self.servicesProvider = servicesProvider
    }
    
    fileprivate lazy var useCase: MovieUseCase = MovieUseCase(imageLoaderService: servicesProvider.imageLoader)
}

extension NavigationComponents {
    
    func navigationController(navigator: Navigator) -> UINavigationController {
        let viewmodel = MovieViewModel(navigator: navigator, useCase: useCase)
        let viewController = MoviesViewController(viewModel: viewmodel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    func moviesDetailsViewController(movie: Movie, bookmarkStatus: Bool) -> UIViewController {
        let viewModel = MovieDetailsViewModel(movie: movie, bookmarkStatus: bookmarkStatus)
        let viewController = MoviesDetailsViewController(viewModel: viewModel)
        return viewController
    }
    
    func movieSearchViewController(movies: [Movie], navigator: Navigator) -> UIViewController {
        let viewModel = MovieSearchViewModel(movies: movies, useCase: useCase, navigator: navigator)
        let viewController = MovieSearchViewController(viewModel: viewModel)
        return viewController
    }
}

protocol AppFlowCoordinatorDependencyProvider: RouterDependencyProvider {}

class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = AppFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {
        let movieFlowCoordinator = RouterCoordinator(window: window, dependencyProvider: dependencyProvider)
        childCoordinators = [movieFlowCoordinator]
        movieFlowCoordinator.start()
    }
}
