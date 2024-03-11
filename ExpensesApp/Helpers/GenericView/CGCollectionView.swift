//
//  CGCollectionView.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit
import Combine
import SkeletonView

@available(iOS 13.0, *)
open class CGCollectionView: UICollectionView {
    //MARK: - Properties
    private var isFetchInProgress = false
    private var currentPage = 0
    private var totalCount = 0
    private var currentCount: Int? {
        get {
            sections.first?.rows.count
        }
    }
    private var paginatedRefresh = false
    private var cancellables = Set<AnyCancellable>()
    private var activityIndicator: UIActivityIndicatorView = {
        var spinner: UIActivityIndicatorView!
        spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        return spinner
    }()
    var skeletonCell: CollectionCell.Type? {
        didSet {
            guard let skeletonCell else {return}
            register(skeletonCell.nib, forCellWithReuseIdentifier: skeletonCell.identifier)
        }
    }
    //MARK: - Publishers
    @Published private var sections = [Section]() {
        didSet {
            hideSkeleton()
        }
    }
    @Published private var paginationPublisher = 0
    @Subject private var selectPublisher: IndexPath?
    @Subject private var deselectPublisher: IndexPath?
    @Action private var refreshPublisher
    @Action private var emptyPublisher
    //MARK: - Closures
    private var paginationIndicator: (() -> UIView)?
    private var onPageChange: ((Int) -> Void)?
    //MARK: - Initializers
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    public init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        initialize()
    }
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    //MARK: - Lifecycle
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    open override var intrinsicContentSize: CGSize {
        return contentSize
    }
    //MARK: - Functions
    @objc private func refresh() {
        refreshPublisher()
    }
    private func initialize() {
        delegate = self
        dataSource = self
        prefetchDataSource = self
        $sections
            .sink { [weak self] newValue in
                guard let self = self else {return}
                if newValue.empty {
                    self.emptyPublisher()
                }
                self.reloadData()
            }.store(in: &cancellables)
    }
    private func load(isReset: Bool = false) {
        currentPage = isReset ? 0: (currentPage + 1)
        isFetchInProgress = true
        paginationPublisher = currentPage
    }
    public func endLoading() {
        hideSkeleton()
        isFetchInProgress = false
        guard refreshControl?.isRefreshing == true else {return}
        refreshControl?.endRefreshing()
    }
}


//MARK: - SkeletonCollectionViewDataSource
@available(iOS 13.0, *)
extension CGCollectionView: SkeletonCollectionViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return skeletonCell?.identifier ?? ""
    }
    public func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = sections[indexPath.section].rows[indexPath.row]
        viewModel.indexPath = indexPath
        return viewModel.cellType.configure(collection: collectionView, viewModel: viewModel) as? UICollectionViewCell ?? UICollectionViewCell()
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
}
//MARK: - CollectionView Delegate
@available(iOS 13.0, *)
extension CGCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectPublisher = indexPath
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselectPublisher = indexPath
    }
}

//MARK: - UIScrollViewDelegate
extension CGCollectionView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        onPageChange?(page)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CGCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = sections[safe: indexPath.section]?.rows[safe: indexPath.row]
        return viewModel?.size ?? collectionView.frame.size
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let viewModel = sections[safe: section]?.rows.first
        return viewModel?.spacing ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let viewModel = sections[safe: section]?.rows.first(where: {$0.insets != nil})
        return viewModel?.insets ?? UIEdgeInsets()
    }
}

//MARK: - Modifiers
@available(iOS 13.0, *)
public extension CGCollectionView {
    @discardableResult func bind(loading: AnyPublisher<Bool, Never>, offset: CGFloat = 0, isSkeleton: Bool = false) -> Self {
        loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                if isSkeleton {
                    self?.showAnimatedGradientSkeleton()
                }else {
                    self?.startLoading(title: "shared.loading".localizedText(), loaderImageName: "loading", offset: offset)
                }
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func onSelect(_ action: @escaping (IndexPath) -> Void) -> Self {
        $selectPublisher
            .receive(on: DispatchQueue.main)
            .sink { indexPath in
                action(indexPath)
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func onDeselect(_ action: @escaping (IndexPath) -> Void) -> Self {
        $deselectPublisher
            .receive(on: DispatchQueue.main)
            .sink { indexPath in
                action(indexPath)
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func refreshable(paginated: Bool = true) -> Self {
        paginatedRefresh = paginated
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return self
    }
    @discardableResult func onRefresh(_ action: (() -> Void)? = nil) -> Self {
        $refreshPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                if let action {
                    action()
                }else if self.paginatedRefresh {
                    self.load(isReset: true)
                }
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func onEmpty(action: @escaping (UICollectionView) -> Void) -> Self {
        $emptyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                action(self)
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func onPageChange(_ action: @escaping (Int) -> Void) -> Self {
        onPageChange = action
        return self
    }
    @discardableResult func pagination(indicator: @escaping () -> UIView) -> Self {
        paginationIndicator = indicator
        return self
    }
}

//MARK: - DataSource
public extension CGCollectionView {
    @discardableResult func bind(_ sections: Published<[Section]>.Publisher) -> Self {
        sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self else {return}
                self.endLoading()
                self.sections = newValue
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func bind(_ rows: Published<Cells>.Publisher) -> Self {
        rows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                guard let self = self else {return}
                self.endLoading()
                guard !newValue.isEmpty else {
                    self.sections = []
                    return
                }
                self.sections = [Section(rows: newValue)]
            }.store(in: &cancellables)
        return self
    }
}

//MARK: - UICollectionViewDataSourcePrefetching
@available(iOS 13.0, *)
extension CGCollectionView: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let currentCount, sections.count == 1, indexPaths.contains(where: {$0.row >= currentCount - 1}), !isFetchInProgress, refreshControl?.isRefreshing == false, totalCount > currentCount else {return}
        load()
        //        tableFooterView = activityIndicator
    }
}
