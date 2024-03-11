//
//  AppSettings.swift
//  VirtualNumber
//
//  Created by Ali Merhie on 9/21/21.
//

import Foundation

struct AppSettings {
    @Storage(key: .lastReceivedVersion) static var lastReceivedVersion = ""
    @Storage(key: .fcmToken) static var fcmToken = ""
    @Storage(key: .appStoreId) static var appStoreId: String? = nil
    @Storage(key: .ignoresUpdates) static var ignoresUpdates = false
    @Storage(key: .isAppleTesting) static var isAppleTesting = false
    @Storage(key: .isLoggedIn) static var isLoggedIn = false
    @Storage(key: .terms) static var terms = ""
    @Storage(key: .notificationCount) static var notificationCount = 0
    @Storage(key: .token, inKeychain: true) static var token = ""
    @Storage(key: .refreshtoken, inKeychain: true) static var refreshtoken = ""
    @Storage(key: .currentLanguageIsRTL) static var currentLanguageIsRTL = false
    @Storage(key: .selectedLanguageDefualt) static var selectedLanguageDefualt = LanguageEnum.english
    @Storage(key: .isLuanchedBefore) static var isLuanchedBefore = false

}

enum StorageKey: String {
    case lastReceivedVersion, baseURL, appStoreId, ignoresUpdates, isAppleTesting, isLoggedIn, userInfo, faqsDefualts, terms, notificationCount, token, refreshtoken, currentLanguageIsRTL, selectedLanguageDefualt, fcmToken, isLuanchedBefore
    var notification: Notification.Name? {
        switch self {
            case .userInfo:
                return .userInfohangedNotification
            case .notificationCount:
                return .notificationCountUpdated
            default:
                return nil
        }
    }
}
