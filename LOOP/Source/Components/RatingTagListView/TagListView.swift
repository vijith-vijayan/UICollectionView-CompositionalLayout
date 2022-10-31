//
//  TagListView.swift
//  LOOP
//
//  Created by Vijith TV on 26/10/22.
//

import UIKit

class TagListView: UIView, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var data: [AnyHashable] = [] {
        didSet {
            update(with: data)
        }
    }
    
    override var clipsToBounds: Bool {
        didSet {
            collectionView.clipsToBounds = clipsToBounds
        }
    }
    
    private var tagViewType: TagViewType?
    private lazy var datasource = makeDataSource()
    private var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
    typealias TagListDataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>
    
    var didSelectRating: ((Int) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type: TagViewType) {
        self.init(frame: .zero)
        self.tagViewType = type
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubviews()
        applyConstraints()
        applyStyles()
        configureCollectionView()
    }
    
    func addSubviews() {
        addSubview(collectionView)
    }
    
    func applyStyles() {
        configuration.movies.design.style.backgroundViewDarkStyle.apply(to: self)
        configuration.movies.design.style.collectionViewStyle.apply(to: collectionView)
    }
    
    func applyConstraints() {
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        addConstraints(constraints)
    }
    
    func configureCollectionView() {
        collectionView.registerCell(of: RatingTagListCell.self)
        collectionView.registerCell(of: GenreCell.self)
        let tagLayout = TagCellLayout(alignment: .center, delegate: self)
        collectionView.collectionViewLayout = (tagViewType == .rating) ? createLayout() : tagLayout
        collectionView.dataSource = datasource
        collectionView.delegate = self
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (index , env) -> NSCollectionLayoutSection? in
            let size = CGSize(width: DesignSystem.shared.sizers.xl * 1.5,
                              height: DesignSystem.shared.sizers.xl)
            return CollectionViewLayoutConfig.ratingsLayout(size, .zero)
        }
    }
    
    func makeDataSource() -> TagListDataSource {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            if let rating = item as? Rating {
                let cell = collectionView.dequeueReusableCell(RatingTagListCell.self, for: indexPath)
                cell.setCount(rating.value)
                return cell
            } else if let genre = item as? String {
                let cell = collectionView.dequeueReusableCell(GenreCell.self, for: indexPath)
                cell.setupGenre(genre)
                return cell
            }
            return nil
        })
        
        return datasource
    }
    
    func update(with data: [AnyHashable]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([RatingsSetion.rating])
        data.forEach {
            snapshot.appendItems([$0])
        }
        self.datasource.apply(snapshot, animatingDifferences: false)
    }
}

extension TagListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RatingTagListCell {
            cell.update(true)
        }
        if let rating = data[indexPath.row] as? Rating {
            didSelectRating?(rating.value)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RatingTagListCell {
            cell.update(false)
        }
    }
}

extension TagListView: TagCellLayoutDelegate {
    
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        if let data = data as? [String] {
            let width = data[index].widthOfString(usingFont: DesignSystem.shared.font.preferredFont(.footnote, .light))
            let size = CGSize(width: width + 10 + DesignSystem.shared.sizers.sm, height: 24)
            return size
        }
        return .zero
    }
}

enum TagViewType {
    case rating
    case genre
}

enum RatingsSetion: Hashable {
    case rating
}

struct Rating: Hashable {
    var value: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    public static func == (lhs: Rating, rhs: Rating) -> Bool {
        lhs.value == rhs.value
    }
}
