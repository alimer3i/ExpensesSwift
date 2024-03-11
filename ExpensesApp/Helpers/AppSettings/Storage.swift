//
//  Storage.swift
//  ExpensesApp
//
//  Created by Ali Merhie on 3/10/24.
//

import Foundation

@propertyWrapper struct Storage<T: Codable> {
    let key: StorageKey
    let defaultValue: T
    let store: any Savable
    init(wrappedValue defaultValue: T, key: StorageKey, inKeychain: Bool = false) {
        self.key = key
        self.defaultValue = defaultValue
        self.store = UserDefaults.standard
    }
    var wrappedValue: T {
        get {
            let decoder = JSONDecoder()
            guard let data = store.data(for: key.rawValue) else {
                return defaultValue
            }
            return (try? decoder.decode(T.self, from: data)) ?? defaultValue
        }
        nonmutating set {
            if let oldData = store.data(for: key.rawValue) {
                UserDefaults.standard.set(oldData, forKey: key.rawValue + "Old")
            }
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(newValue) else {return}
            store.set(data: data, for: key.rawValue)
            if let notification = key.notification {
                NotificationCenter.default.post(name: notification, object: nil)
            }
        }
    }
    var projectedValue: T {
        get {
            let decoder = JSONDecoder()
            guard let data = store.data(for: key.rawValue + "Old") else {
                return defaultValue
            }
            return (try? decoder.decode(T.self, from: data)) ?? defaultValue
        }
    }
}

protocol Savable {
    func set(data: Data, for key: String)
    func data(for key: String) -> Data?
}

extension UserDefaults: Savable {
    func set(data: Data, for key: String) {
        set(data, forKey: key)
    }
    func data(for key: String) -> Data? {
        return data(forKey: key)
    }
}
