//
//  BaseVM.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 9/1/21.
//

import Foundation
import Combine

class BaseVM: CancellableProvider {
//MARK: - Properties
    @SubjectAction<String> var showLoader
    @SubjectAction<Alert> var showAlert
    @Action var hideLoader
    @Action var startSkeletonAnimation
    @Action var hideSkeletonAnimation
    @Action var popViewController
    @Action var dismiss
    var cancellables = Set<AnyCancellable>()
//MARK: - Lifecycle
    init() {
        print("BASEVM")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Memory to be released soon \(self)")
    }
//MARK: - Functions
    func pageDidLoad() {
    }
}
