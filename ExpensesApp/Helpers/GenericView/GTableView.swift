//
//  GTableView.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

open class GTableView: UITableView {
//MARK: - Properties
    private var isFetchInProgress = false
    private var currentPage = 0
    private var totalCount = 0
    private var deselectOnSelection = false
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
    private var leadingSwipe: ((IndexPath) -> UISwipeActionsConfiguration?)?
    private var trailingSwipe: ((IndexPath) -> UISwipeActionsConfiguration?)?
    private var header: ((Int) -> SectionView)?
    private var footer: ((Int) -> SectionView)?
    private var onPagination: ((Int) -> Void)?
    private var onSelect: ((IndexPath) -> Void)?
    private var onDeSelect: ((IndexPath) -> Void)?
    private var onEmpty: ((UITableView) -> Void)?
    private var onRefresh: (() -> Void)?
//MARK: - Initializers
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    public init() {
        super.init(frame: .zero, style: .plain)
        initialize()
    }
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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
    func endLoading() {
        isFetchInProgress = false
        tableFooterView = nil
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

//MARK: - TableView DataSource
extension GTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = sections[indexPath.section].rows[indexPath.row]
        viewModel.indexPath = indexPath
        return viewModel.cellType.configure(collection: tableView, viewModel: viewModel) as? UITableViewCell ?? UITableViewCell()
    }
}

//MARK: - TableView Delegate
extension GTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if deselectOnSelection {
            deselectRow(at: indexPath, animated: true)
        }
        onSelect?(indexPath)
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        onDeSelect?(indexPath)
    }
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return leadingSwipe?(indexPath)
    }
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return trailingSwipe?(indexPath)
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header?(section).view
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer?(section).view
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header?(section).title
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footer?(section).title
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return header?(section).height ?? UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footer?(section).height ?? UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = sections[indexPath.section].rows[indexPath.row]
        return viewModel.height ?? UITableView.automaticDimension
    }
}

//MARK: - Modifiers
public extension GTableView {
    @discardableResult func onSelect(deselect: Bool = false, _ action: @escaping (IndexPath) -> Void) -> Self {
        deselectOnSelection = deselect
        self.onSelect = action
        return self
    }
    @discardableResult func onDeselect(_ action: @escaping (IndexPath) -> Void) -> Self {
        self.onDeSelect = action
        return self
    }
    @discardableResult func onTrailingSwipe(_ action: @escaping (IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        self.trailingSwipe = action
        return self
    }
    @discardableResult func onLeadingSwipe(_ action: @escaping (IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        self.leadingSwipe = action
        return self
    }
    @discardableResult func onRefresh(paginated: Bool = false, _ action: (() -> Void)? = nil) -> Self {
        paginatedRefresh = paginated
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.onRefresh = action
        return self
    }
    @discardableResult func onEmpty(action: @escaping (UITableView) -> Void) -> Self {
        self.onEmpty = action
        return self
    }
    @discardableResult func onPagination(_ action: @escaping (Int) -> Void) -> Self {
        self.onPagination = action
        return self
    }
    @discardableResult func pagination(indicator: @escaping () -> UIView) -> Self {
        paginationIndicator = indicator
        return self
    }
}

//MARK: - Sections
public extension GTableView {
    @discardableResult func header(content: @escaping (Int) -> SectionView) -> Self {
        header = content
        return self
    }
    @discardableResult func footer(content: @escaping (Int) -> SectionView) -> Self {
        footer = content
        return self
    }
}

//MARK: - DataSource
public extension GTableView {
    func update(_ sections: [Section]) {
        endLoading()
        self.sections = sections
        reloadData()
    }
    func update(_ rows: Cells, totalCount: Int? = nil) {
        endLoading()
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

//MARK: - UITableViewDataSourcePrefetching
extension GTableView: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let currentCount, sections.count == 1, indexPaths.contains(where: {$0.row >= currentCount - 1}), !isFetchInProgress, refreshControl?.isRefreshing == false, totalCount > currentCount else {return}
        load()
        tableFooterView = paginationIndicator?() ?? activityIndicator
    }
}
