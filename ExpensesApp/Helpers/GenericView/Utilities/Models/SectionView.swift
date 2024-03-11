//
//  SectionView.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import UIKit

public struct SectionView {
//MARK: - Properties
    internal var view: UIView?
    internal var title: String?
    internal var height: CGFloat?
//MARK: - Modifiers
    public static func with(view: UIView?) -> Self {
        return SectionView(view: view)
    }
    public static func with(title: String?) -> Self {
        return SectionView(title: title)
    }
    public func with(height: CGFloat) -> Self {
        return SectionView(view: view, title: title, height: height)
    }
}
