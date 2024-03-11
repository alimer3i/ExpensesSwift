//
//  CGTableView.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit
import Combine
import SkeletonView

open class CGTableView: UITableView {
//MARK: - Properties
    private var isFetchInProgress = false
    private var currentPage = 0
    weak var scrollViewDelegate: UIScrollViewDelegate?
    private var paginatedRefresh = false
    private var cancellables = Set<AnyCancellable>()
    private var dataFailure = false
    private var tapGesture: UITapGestureRecognizer?
    private var isEdtingEnabled: Bool = false
    private var activityIndicator: UIActivityIndicatorView = {
        var spinner: UIActivityIndicatorView!
        spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        return spinner
    }()
    private var sections = [Section]() {
        didSet {
            if sections.empty {
                emptyPublisher()
            }
            reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    private var currentCount: Int? {
        get {
            sections.first?.rows.count
        }
    }
    var skeletonCell: CollectionCell.Type? {
        didSet {
            guard let skeletonCell else {return}
            register(skeletonCell.nib, forCellReuseIdentifier: skeletonCell.identifier)
        }
    }
//MARK: - Publishers
    @Published var totalCount = 0
    @Published private var paginationPublisher = 0
    @Subject private var selectPublisher: IndexPath?
    @Subject private var deselectPublisher: IndexPath?
    @Action private var refreshPublisher
    @Action private var emptyPublisher
//MARK: - Closures
    private var leadingSwipe: ((IndexPath) -> UISwipeActionsConfiguration?)?
    private var trailingSwipe: ((IndexPath) -> UISwipeActionsConfiguration?)?
    private var header: ((Int) -> SectionView)?
    private var footer: ((Int) -> SectionView)?
    private var paginationIndicator: (() -> UIView)?
    private var onWillDisplay: ((UITableView) -> Void)?
    private var onStartEditing: ((IndexPath, IndexPath) -> Void)?
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
        if paginatedRefresh {
            load(isReset: true)
        }else {
            refreshPublisher()
        }
    }
    private func initialize() {
        delegate = self
        dataSource = self
        prefetchDataSource = self
        isEditing = false
    }
    private func load(isReset: Bool = false) {
        currentPage = isReset ? 0: (currentPage + 1)
        isFetchInProgress = true
        paginationPublisher = currentPage
    }
    public func endLoading() {
        isFetchInProgress = false
        tableFooterView = nil
        guard refreshControl?.isRefreshing == true else {return}
        refreshControl?.endRefreshing()
    }
}

//MARK: - UITableViewDataSource
extension CGTableView: SkeletonTableViewDataSource {
    public func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    public func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return skeletonCell?.identifier ?? ""
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.rows.count ?? 0
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = sections[safe: indexPath.section]?.rows[safe: indexPath.row] else {
            return UITableViewCell()
        }
        viewModel.indexPath = indexPath
        return viewModel.cellType.configure(collection: tableView, viewModel: viewModel) as? UITableViewCell ?? UITableViewCell()
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onWillDisplay?(tableView)
    }
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        beginUpdates()
        onStartEditing?(sourceIndexPath, destinationIndexPath)
        endUpdates()
    }
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//MARK: - UITableViewDelegate
extension CGTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectPublisher = indexPath
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deselectPublisher = indexPath
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
        return header?(section).height ?? 0
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footer?(section).height ?? 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = sections[safe: indexPath.section]?.rows[safe: indexPath.row]
        return viewModel?.height ?? UITableView.automaticDimension
    }
}

//MARK: - UIScrollViewDelegate
extension CGTableView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
}

//MARK: - UITableViewDataSourcePrefetching
extension CGTableView: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let currentCount, sections.count == 1, indexPaths.contains(where: {$0.row >= currentCount - 1}), !isFetchInProgress, (refreshControl?.isRefreshing ?? false) == false, totalCount > currentCount else {return}
        load()
        tableFooterView = paginationIndicator?() ?? activityIndicator
    }
}

//MARK: - Modifiers
public extension CGTableView {
    @discardableResult func bind(error: Published<Error?>.Publisher, _ action: @escaping () -> Void) -> Self {
        error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard error != nil else {return}
                self?.showEmptyDataSet(title: "shared.reload".localizedText(), image: UIImage(named: "reloadError")!, verticalOffset: -120, space: -10) {
                    action()
                }
                self?.dataFailure = true
                self?.sections = []
            }.store(in: &cancellables)
        return self
    }
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
    @discardableResult func onSelect(shouldDeselect: Bool = true, _ action: @escaping (IndexPath) -> Void) -> Self {
        $selectPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.deselectRow(at: indexPath, animated: true)
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
    @discardableResult func onTrailingSwipe(_ action: @escaping (IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        self.trailingSwipe = action
        return self
    }
    @discardableResult func onLeadingSwipe(_ action: @escaping (IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        self.leadingSwipe = action
        return self
    }
    @discardableResult func isEditing(value: Bool) -> Self {
        self.isEditing = value
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
                guard let self else {return}
                if let action {
                    action()
                }else if self.paginatedRefresh {
                    self.load(isReset: true)
                }
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func onEmpty(action: @escaping (UITableView) -> Void) -> Self {
        $emptyPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else {return}
                action(self)
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func onPagination(_ action: @escaping (Int) -> Void) -> Self {
        $paginationPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { newValue in
                action(newValue)
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func pagination(indicator: @escaping () -> UIView) -> Self {
        paginationIndicator = indicator
        return self
    }
}

//MARK: - Sections
public extension CGTableView {
    @discardableResult func header(content: @escaping (Int) -> SectionView) -> Self {
        header = content
        return self
    }
    @discardableResult func footer(content: @escaping (Int) -> SectionView) -> Self {
        footer = content
        return self
    }
}

//MARK: - Editing Order
public extension CGTableView {
    @discardableResult func onEditing(block: @escaping (IndexPath, IndexPath) -> Void) -> Self {
        onStartEditing = block
        return self
    }
    
    @discardableResult func onWillDisplay(block: @escaping (UITableView) -> Void) -> Self {
        onWillDisplay = block
        return self
    }
}

//MARK: - DataSource
public extension CGTableView {
    @discardableResult func bind(_ sections: Published<[Section]>.Publisher) -> Self {
        sections
            .sink { [weak self] newValue in
                guard let self else {return}
                self.endLoading()
                self.sections = newValue
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func bind(count publisher: Published<Int>.Publisher) -> Self {
        publisher
            .sink { [weak self] newValue in
                guard let self else {return}
                self.totalCount = newValue
            }.store(in: &cancellables)
        return self
    }
    @discardableResult func bind(_ rows: Published<Cells>.Publisher) -> Self {
        rows
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
