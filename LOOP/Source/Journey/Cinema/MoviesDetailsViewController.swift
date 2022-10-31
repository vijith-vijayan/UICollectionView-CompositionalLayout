//
//  Created by Vijith on 20/10/2022.
//

import UIKit
import Combine

class MoviesDetailsViewController: UIViewController, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var blurView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hStackView: UIStackView  = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = DesignSystem.shared.sizers.xl
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var close: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        button.setImage(configuration.movies.design.closeIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel: MovieDetailsViewModelType
    private var bag: [AnyCancellable] = []
    private var appear = PassthroughSubject<Void, Never>()
    private var bookmark = PassthroughSubject<Bool, Never>()
    private var data: [DetailsSection] = []
    private lazy var datasource = makeDatasource()
    private var snapshot = NSDiffableDataSourceSnapshot<DetailsSection, AnyHashable>()
    private var movieTitle: String?
    typealias MovieDetailsDataSource = UICollectionViewDiffableDataSource<DetailsSection, AnyHashable>

    init(viewModel: MovieDetailsViewModelType) {
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
    
    func bind(to viewModel: MovieDetailsViewModelType) {
        let input = MovieDetailsViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               bookmark: bookmark.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.sink { [unowned self] state in
            self.render(state)
        }.store(in: &bag)
    }
    
    func setup() {
        navigationController?.isNavigationBarHidden = false
        bind(to: viewModel)
        applyStyles()
        addSubviews()
        applyConstraints()
        configureCollectionView()
    }
    
    func applyStyles() {
        configuration.movies.design.style.backgroundViewLightStyle.apply(to: view)
        configuration.movies.design.style.movieDetailsTitleLabelStyle.apply(to: titleLabel)
    }
    
    func addSubviews() {
        view.addSubview(blurView)
        view.addSubview(hStackView)
        view.addSubview(collectionView)
        
        hStackView.addArrangedSubview(titleLabel)
        hStackView.addArrangedSubview(bookmarkImageView)
        hStackView.addArrangedSubview(close)
    }
    
    func applyConstraints() {
        let constrainst = [
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl + DesignSystem.shared.sizers.md),
            
            hStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: DesignSystem.shared.sizers.lg),
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DesignSystem.shared.sizers.xl),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DesignSystem.shared.sizers.xl),
            hStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: DesignSystem.shared.sizers.xl),
            
            bookmarkImageView.widthAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.md),
            close.widthAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl),
            
            collectionView.topAnchor.constraint(equalTo: hStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        view.addConstraints(constrainst)
    }
    
    func configureCollectionView() {
        collectionView.registerCell(of: MainFactsCell.self)
        collectionView.registerCell(of: OverviewCell.self)
        collectionView.registerCell(of: CastAndCrewCell.self)
        collectionView.registerCell(of: KeyFactsCell.self)
        collectionView.registerSupplementaryView(of: MovieDetailsHeader.self, with: CollectionViewLayoutConfig.sectionHeaderElementKind)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = datasource
        collectionView.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (index , env) -> NSCollectionLayoutSection? in
            let data = self.data[index]
            switch data {
            case .mainFacts(_): return CollectionViewLayoutConfig.mainFactsLayout
            case .overview(_): return CollectionViewLayoutConfig.overviewLayout
            case .actors(_), .director(_):  return CollectionViewLayoutConfig.castAndCrewLayout
            case .keyFacts(let keyFacts): return CollectionViewLayoutConfig.keyFactsLayout(keyFacts.count)
            }
        }
    }
    
    func makeDatasource() -> MovieDetailsDataSource {
        let datasource = MovieDetailsDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            
            if let mainFacts = item as? Movie {
                let cell = collectionView.dequeueReusableCell(MainFactsCell.self, for: indexPath)
                cell.setupDTO(mainFacts)
                return cell
            } else if let overview = item as? String {
                let cell = collectionView.dequeueReusableCell(OverviewCell.self, for: indexPath)
                cell.setupOverviewDTO(overview: overview)
                return cell
            } else if let keyFacts = item as? KeyFacts {
                let cell = collectionView.dequeueReusableCell(KeyFactsCell.self, for: indexPath)
                cell.setupDTO(title: keyFacts.name, value: keyFacts.value)
                return cell
            } else if let director = item as? Director {
                let cell = collectionView.dequeueReusableCell(CastAndCrewCell.self, for: indexPath)
                cell.setImageDTO(imageUrl: director.pictureURL, name: director.name, character: "")
                return cell
            } else if let actor = item as? Cast {
                let cell = collectionView.dequeueReusableCell(CastAndCrewCell.self, for: indexPath)
                cell.setImageDTO(imageUrl: actor.pictureURL, name: actor.name, character: actor.character)
                return cell
            }
            return nil
        }
        
        datasource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            let section = self.data[indexPath.section]
            
            if kind == CollectionViewLayoutConfig.sectionHeaderElementKind {
                let supplementaryView = collectionView.dequeueReusableSupplementaryView(MovieDetailsHeader.self, kind: CollectionViewLayoutConfig.sectionHeaderElementKind, for: indexPath)
                switch section {
                case .mainFacts(_):
                    supplementaryView.headerTitle = ""
                case .overview(_):
                    supplementaryView.headerTitle = "Overview"
                case .keyFacts(_):
                    supplementaryView.headerTitle = "Key Facts"
                case .director(_):
                    supplementaryView.headerTitle = "Directors"
                case .actors(_):
                    supplementaryView.headerTitle = "Actors"
                }
                return supplementaryView
            }
            return nil
        }
        return datasource
    }
    
    func update(with data: [DetailsSection], animate: Bool = true) {
        snapshot.deleteAllItems()
        data.forEach {
            snapshot.appendSections([$0])
            switch $0 {
            case .mainFacts(let movie):
                snapshot.appendItems([movie])
            case .overview(let overview):
                snapshot.appendItems([overview])
            case .director(let director):
                snapshot.appendItems([director])
            case .actors(let cast):
                snapshot.appendItems(cast)
            case .keyFacts(let keyFacts):
                snapshot.appendItems(keyFacts)
            }
        }
        datasource.apply(snapshot, animatingDifferences: animate)
    }
    
    func render(_ state: MovieDetailsState) {
        switch state {
        case .idle:
            break
        case .movies(let movie):
            movieTitle = movie.title
            let data = dataObject(movie: movie)
            self.data = data
            update(with: data)
        case .failure(let error):
            debugPrint("Error: \(error.localizedDescription)")
        case .bookmark(let status):
            if status {
                bookmarkImageView.image = configuration.movies.design.bookmarkBlackIcon
            }
        }
    }
    
    func dataObject(movie: Movie) -> [DetailsSection] {
        guard let cast = movie.cast, let director = movie.director else { return [] }
        guard let language = movie.language else { return []}
        let keyFacts: [KeyFacts] = [
            KeyFacts(name: "Budget", value: "$ \(movie.budget ?? 0)"),
            KeyFacts(name: "Revenue", value: "$ \(movie.revenue ?? 0)"),
            KeyFacts(name: "Original Language", value: (language == "en") ? "English" : ""),
            KeyFacts(name: "Rating", value: String(format: "%.2f", movie.rating ?? 0.00))
        ]
        return [
            .mainFacts(movie),
            .overview(movie.overview ?? ""),
            .director(director),
            .actors(cast),
            .keyFacts(keyFacts)
        ]
    }
    
    @objc
    func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension MoviesDetailsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? MainFactsCell {
            if scrollView.contentOffset.y >= cell.posterImageShadowView.bounds.height + (cell.vStackView.bounds.height - 20) {
                titleLabel.text = movieTitle
            } else {
                titleLabel.text = ""
            }
        }
    }
}

enum DetailsSection: Hashable {
    case mainFacts(Movie)
    case overview(String)
    case keyFacts([KeyFacts])
    case director(Director)
    case actors([Cast])
}
