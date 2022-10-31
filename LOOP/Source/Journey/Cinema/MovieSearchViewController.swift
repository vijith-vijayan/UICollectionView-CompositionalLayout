//
//  Created by Vijith TV on 25/10/22.
//

import UIKit
import Combine

class MovieSearchViewController: UIViewController, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchBarView: SearchTopComponentView = {
        let view = SearchTopComponentView()
        view.didBeignSearch = { [weak self] query in
            self?.search.send((query, .query))
        }
        view.didEndSearch = { [weak self] in
            self?.hasEnded.send(())
        }
        view.didPressBack = { [weak self] in
            self?.backPressed.send(())
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tagListView: TagListView = {
        let tagList = TagListView(type: .rating)
        tagList.translatesAutoresizingMaskIntoConstraints = false
        tagList.didSelectRating = { [weak self] query in
            self?.search.send(("\(query)", .rating))
        }
        return tagList
    }()
    
    private let viewModel: MovieSearchViewModelType
    private var bag: [AnyCancellable] = []
    private let appear = PassthroughSubject<Void, Never>()
    private let search = PassthroughSubject<(String, SearchType), Never>()
    private let selection = PassthroughSubject<Movie, Never>()
    private let hasEnded = PassthroughSubject<Void, Never>()
    private let backPressed = PassthroughSubject<Void, Never>()
    private let bookmark = PassthroughSubject<(Int, Bool), Never>()
    private var data: [Section] = [.staffPicks([])]
    private lazy var datasource = makeDataSource()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
    
    typealias SearchDataSource = UICollectionViewDiffableDataSource<Section, Movie>

    init(viewModel: MovieSearchViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func bind(to viewModel: MovieSearchViewModelType) {
        
        let input = MovieSearchViewModelInput(appear: appear.eraseToAnyPublisher(),
                                              search: search.eraseToAnyPublisher(),
                                              selection: selection.eraseToAnyPublisher(),
                                              hasEnded: hasEnded.eraseToAnyPublisher(),
                                              backPressed: backPressed.eraseToAnyPublisher(),
                                              bookmark: bookmark.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        output.sink { [unowned self] state in
            self.render(state)
        }.store(in: &bag)
    }
    
    func setup() {
        bind(to: viewModel)
        setupCollectionView()
        addSubviews()
        applyConstraints()
        applyStyles()
    }
    
    private func setupCollectionView() {
        collectionView.registerCell(of: StaffPicksCell.self)
        collectionView.dataSource = datasource
        
        tagListView.data = [Rating(value: 5),
                            Rating(value: 4),
                            Rating(value: 3),
                            Rating(value: 2),
                            Rating(value: 1)]
    }
    
    func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(searchBarView)
        view.addSubview(tagListView)
    }
    
    func applyConstraints() {
        let constraints = [
            searchBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: DesignSystem.shared.sizers.xl * 2),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DesignSystem.shared.sizers.xl),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DesignSystem.shared.sizers.xl),
            searchBarView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 1.6),
            
            tagListView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: DesignSystem.shared.sizers.lg),
            tagListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DesignSystem.shared.sizers.xl),
            tagListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagListView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl),
            
            collectionView.topAnchor.constraint(equalTo: tagListView.topAnchor, constant: DesignSystem.shared.sizers.lg),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            
        ]
        view.addConstraints(constraints)
    }
    
    func applyStyles() {
        configuration.movies.design.style.backgroundViewDarkStyle.apply(to: view)
        configuration.movies.design.style.collectionViewStyle.apply(to: collectionView)
        configuration.movies.design.style.tagListViewDetailsStyle.apply(to: tagListView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (index , env) -> NSCollectionLayoutSection? in
            return CollectionViewLayoutConfig.staffPicksLayoutConfig(false)
        }
    }
    
    func render(_ state: MovieSearchState) {
        switch state {
        case .appear(let movies):
            data = [.staffPicks(movies)]
            update(with: [.staffPicks(movies)])
        case .loading:
            break
        case .success(let movies):
            collectionView.restore()
            update(with: [.staffPicks(movies)])
        case .failure(let error):
            debugPrint("Error: \(error.localizedDescription)")
        case .noResults:
            update(with: [.staffPicks([])])
            collectionView.setEmptyMessage("No Movies found 😞", with: configuration.movies.design.seachEmptyIcon!)
        }
    }
    
    func makeDataSource() -> SearchDataSource {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StaffPicksCell.reuseIdentifier,
                                                                for: indexPath) as? StaffPicksCell else {
                fatalError("Cannot create poster cell") }
            cell.setupDTO(movie)
            cell.bookmark = { [weak self] id, isBookmarked in
                self?.bookmark.send((id, isBookmarked))
            }
            return cell
        })
        
        return datasource
    }
    
    func update(with data: [Section],
                animate: Bool = true) {
        snapshot.deleteAllItems()
        data.forEach {
            snapshot.appendSections([$0])
            switch $0 {
            case .staffPicks(let staffPicks):
                snapshot.appendItems(staffPicks)
            default:
                break
            }
        }
        datasource.apply(snapshot, animatingDifferences: animate)
    }
}
