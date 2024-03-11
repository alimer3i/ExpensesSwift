//
//  AppTarget.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

enum AppTargets {
    case skeleton, skeletonTarget
    
    static var target: AppTargets {
#if Skeleton
        return .skeleton
#else
        return .skeletonTarget
#endif
    }
}
