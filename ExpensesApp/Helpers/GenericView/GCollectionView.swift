//
//  GCollectionView.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

open class GCollectionView: UICollectionView {
//MARK: - Properties
    private var isFetchInProgress = false
    private var currentPage = 0
    private var totalCount = 0
    private var paginatedRefresh = false
    private var activityIndicator: UIActivityIndicatorView = {
        var spinner: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(style: .medium)
        }else {
            spinner = UIActivityIndicatorView(style: .gray)
        }
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        return spinner
    }()
//MARK: - Data
    private var sections = [Section]() {
         didSet {
             guard refreshControl?.isRefreshing == false else {return}
             if sections.empty {
                 onEmpty?(self)
             }
             reloadData()
         }
     }
    private var currentCount: Int? {
        get {
            sections.first?.rows.count
        }
    }
//MARK: - Closures
    private var paginationIndicator: (() -> UIView)?
    private var onPagination: ((Int) -> Void)?
    private var onSelect: ((IndexPath) -> Void)?
    private var onDeSelect: ((IndexPath) -> Void)?
    private var onEmpty: ((UICollectionView) -> Void)?
    private var onRefresh: (() -> Void)?
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
        if let onRefresh = onRefresh {
            onRefresh()
        }else if paginatedRefresh {
            load(isReseting: true)
        }
    }
    private func initialize() {
        delegate = self
        dataSource = self
        prefetchDataSource = self
    }
    private func load(isReseting: Bool = false) {
        currentPage = isReseting ? 0: (currentPage + 1)
        isFetchInProgress = true
        onPagination?(currentPage)
    }
    public func endLoading() {
        isFetchInProgress = false
//        tableFooterView = nil
        guard refreshControl?.isRefreshing == true else {return}
        refreshControl?.endRefreshing()
    }
    func reload() {
        if sections.empty {
            onEmpty?(self)
        }else {
            reloadData()
        }
    }
}

//MARK: - CollectionView DataSource
extension GCollectionView: UICollectionViewDataSource {
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
extension GCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelect?(indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        onDeSelect?(indexPath)
    }
}

//MARK: - Modifiers
public extension GCollectionView {
    @discardableResult func onSelect(_ action: @escaping (IndexPath) -> Void) -> Self {
        self.onSelect = action
        return self
    }
    @discardableResult func onDeselect(_ action: @escaping (IndexPath) -> Void) -> Self {
        self.onDeSelect = action
        return self
    }
    @discardableResult func refreshable(paginated: Bool = true) -> Self {
        paginatedRefresh = paginated
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return self
    }
    @discardableResult func onRefresh(_ action: (() -> Void)? = nil) -> Self {
        self.onRefresh = action
        return self
    }
    @discardableResult func onEmpty(action: @escaping (UICollectionView) -> Void) -> Self {
        self.onEmpty = action
        return self
    }
    @discardableResult func pagination(indicator: @escaping () -> UIView) -> Self {
        paginationIndicator = indicator
        return self
    }
}

//MARK: - DataSource
public extension GCollectionView {
    func update(_ sections: [Section]) {
        self.sections = sections
        reloadData()
    }
    func update(_ rows: Cells, totalCount: Int? = nil) {
        if let totalCount = totalCount {
            self.totalCount = totalCount
        }
        guard !rows.isEmpty else {
            self.sections = []
            return
        }
        if self.sections.isEmpty {
            self.sections = [Section(rows: rows)]
        }else {
            self.sections[0].rows = rows
        }
        reloadData()
    }
    func update(totalCount: Int) {
        self.totalCount = totalCount
    }
}

//MARK: - UICollectionViewDataSourcePrefetching
@available(iOS 13.0, *)
extension GCollectionView: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let currentCount, sections.count == 1, indexPaths.contains(where: {$0.row >= currentCount - 1}), !isFetchInProgress, refreshControl?.isRefreshing == false, totalCount > currentCount else {return}
        load()
//        tableFooterView = activityIndicator
    }
}
