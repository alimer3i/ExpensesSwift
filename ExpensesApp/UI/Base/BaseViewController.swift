//
//  BaseViewController.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit
import SkeletonView
import Combine

class BaseViewController: UIViewController, CancellableProvider {
//MARK: - Properties
    var baseViewModel: BaseVM
    var isLightStatus = false
    var cancellables = Set<AnyCancellable>()
    @Subject var dismissCoordinatorController: DismissStyle?
//MARK: - Initializers
    init(viewModel: BaseVM) {
        baseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - Lifecycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        NotificationCenter.default.post(name: .themeChanged, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            dismissCoordinatorController = .pop
        }else if isBeingDismissed || navigationController?.isBeingDismissed == true {
            dismissCoordinatorController = .dismiss
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = isLightStatus ? .lightContent : .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPublishers()
        baseViewModel.pageDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppDidBecomeActiveNotification(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    func bindPublishers() {
        baseViewModel.$popViewController
            .sink(self) { _, object in
                object.navigationController?.popViewController(animated: true)
            }
        baseViewModel.$dismiss
            .sink(self) { arguments, strongSelf in
                strongSelf.dismiss(animated: true)
            }
        baseViewModel.$startSkeletonAnimation
            .sink(self) { _, object in
                object.view.showAnimatedGradientSkeleton()
            }
        baseViewModel.$hideSkeletonAnimation
            .sink(self) { _, object in
                object.view.hideSkeleton()
            }
        baseViewModel.$showAlert
            .sink(self) { alert, object in
                object.present(alert.alert, animated: true)
            }
    }
//MARK: - Actions
    @IBAction func backPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }
//MARK: - Notification Functions
    @objc public func setUpPage(showLoader: Bool = true) {
    }
    @objc func reloadPage(_ notification: Notification) {
        self.viewDidLoad()
    }
    @objc func handleAppDidBecomeActiveNotification(notification: Notification) {
        print("did become active \(self)")
        setUpPage(showLoader: false)
    }
    @objc func willEnterForeground() {
        print("will enter foreground \(self)")
    }
    @objc func keyboardWillAppear() {
        print("keyboard will appear \(self)")
    }
    @objc func keyboardWillDisappear() {
        print("keyboard will disappear \(self)")
    }
//MARK: - Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Memory to be released soon \(self)")
    }
}

enum DismissStyle {
    case pop, dismiss
}
