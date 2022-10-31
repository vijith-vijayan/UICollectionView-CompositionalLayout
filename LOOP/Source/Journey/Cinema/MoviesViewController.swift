//
//  Created by Vijith on 20/10/2022.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {
    
    // MARK: - DEPENDENCY INJECTION
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    // MARK: - UI ELEMNETS
    private lazy var slantedView: SlantedView = {
        let view = SlantedView(frame: .zero)
        view.accessibilityIdentifier = AccessibilityIdentifiers.Movies.slantedViewId
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = AccessibilityIdentifiers.Movies.collectionViewId
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private let viewModel: MovieViewModelType
    
    private let selection = PassthroughSubject<Movie, Never>()
    private let openSearch = PassthroughSubject<[Movie], Never>()
    private let bookmark = PassthroughSubject<(Int, Bool), Never>()
    private var data: [Section] = [.movies([]), .staffPicks([])]
    private var movies: [Movie] = []
    private var cancellables: [AnyCancellable] = []
    private lazy var datasource = makeDatasource()
    private var slantedViewTop: NSLayoutConstraint?
    private var didChangeView: Bool = false
    
    typealias MovieDataSource = UICollectionViewDiffableDataSource<Section, Movie>

    init(viewModel: MovieViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(to: viewModel)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if didChangeView {
            didChangeView = false
            update(with: data)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        applyStyles()
    }
    
    private func setup() {
        addSubViews()
        setupSlantedView()
        setupCollectionView()
    }
    
    // MARK: - SETUP COLLECTION VIEW
    private func setupCollectionView() {
        collectionView.registerCell(of: FavouritesCell.self)
        collectionView.registerCell(of: StaffPicksCell.self)
        collectionView.registerCell(of: SeeAllCell.self)
        collectionView.registerSupplementaryView(of: SectionHeader.self, with: CollectionViewLayoutConfig.sectionHeaderElementKind)
        collectionView.dataSource = datasource
        collectionView.delegate = self
    }

    // MARK: - ADD SUBVIEW TO VIEW
    private func addSubViews() {
        view.addSubview(slantedView)
        view.addSubview(collectionView)
        applyConstraints()
    }
    
    // MARK: - APPLY CONSTRAINTS TO SUBVIEWS
    private func applyConstraints() {
        
        slantedViewTop = slantedView.topAnchor.constraint(equalTo: view.topAnchor)
        
        let constraints = [
            slantedViewTop,
            slantedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slantedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slantedView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                constant: view.bounds.size.height * 0.5),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        view.addConstraints(constraints.compactMap{ $0 })
    }
    
    // MARK: - APPLY STYLES TO UI ELEMENTS
    private func applyStyles() {
        configuration.movies.design.style.backgroundViewLightStyle.apply(to: view)
        configuration.movies.design.style.collectionViewStyle.apply(to: collectionView)
    }
    
    // MARK: - SETUP SLANTED BACKGROUND VIEW
    private func setupSlantedView() {
        let rect = CGRect(x: 0,
                          y: 0,
                          width: view.bounds.width,
                          height: view.bounds.size.height * 0.4)
        slantedView.setup(with: rect)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (index , env) -> NSCollectionLayoutSection? in
            let section = self.data[index]
            switch section {
            case .movies(_):
                return CollectionViewLayoutConfig.favLayoutConfig
            case .staffPicks(_):
                return CollectionViewLayoutConfig.staffPicksLayoutConfig(true)
            }
        }
    }
    
    private func bind(to viewModel: MovieViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = MovieViewModelInput(selection: selection.eraseToAnyPublisher(),
                                        openSearch: openSearch.eraseToAnyPublisher(),
                                        bookmark: bookmark.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.sink { [unowned self] state in
            self.render(state)
        }
        .store(in: &cancellables)
    }
    
    private func render(_ state: MovieState) {
        switch state {
        case .movies(let movies):
            self.movies = movies
            data = [.movies(movies.limit(4))]
        case .staffPicks(let staffPicks):
            data.append(.staffPicks(staffPicks))
        default:
            break
        }
        update(with: data)
    }
    
    func makeDatasource() -> MovieDataSource {
        
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, movie) -> UICollectionViewCell? in
            
            let section = self.data[indexPath.section]
            switch section {
            case .movies(_):
                if indexPath.row > 2 {
                    let cell = collectionView.dequeueReusableCell(SeeAllCell.self, for: indexPath)
                    return cell
                }
                let cell = collectionView.dequeueReusableCell(FavouritesCell.self, for: indexPath)
                cell.setup(movie)
                return cell
                
            case .staffPicks(_):
                let cell = collectionView.dequeueReusableCell(StaffPicksCell.self, for: indexPath)
                cell.setupDTO(movie)
                cell.bookmark = { [weak self] id, isBookmarked in
                    self?.bookmark.send((id, isBookmarked))
                }
                return cell
            }
            
        })
        
        datasource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            let section = self.data[indexPath.section]
            
            if kind == CollectionViewLayoutConfig.sectionHeaderElementKind {
                let supplementaryView = collectionView.dequeueReusableSupplementaryView(SectionHeader.self, kind: kind, for: indexPath)
                supplementaryView.sectionConfig = section
                supplementaryView.didPressSearch = { [weak self] in
                    self?.openSearch.send(self?.movies ?? [])
                }
                return supplementaryView
            }
            return nil
        }
        return datasource
    }
    
    func update(with data: [Section], animate: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        data.forEach {
            snapshot.appendSections([$0])
            switch $0 {
            case .movies(let movies):
                snapshot.appendItems(movies)
            case .staffPicks(let staffPicks):
                snapshot.appendItems(staffPicks)
            }
        }
        self.datasource.apply(snapshot, animatingDifferences: animate)
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = data[indexPath.section]
        switch section {
        case .movies(let movie):
            if indexPath.row == 3 {
                didChangeView = true
                openSearch.send(self.movies)
            } else {
                selection.send(movie[indexPath.row])
            }
            
        case .staffPicks(let staffPicks):
            selection.send(staffPicks[indexPath.row])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.y
        slantedViewTop?.constant = -offSet
        view.layoutIfNeeded()
        view.backgroundColor = offSet > 0 ? DesignSystem.shared.colors.backgroundColor : .white
    }
}

enum Section: Hashable {
    case movies([Movie])
    case staffPicks([Movie])
}
