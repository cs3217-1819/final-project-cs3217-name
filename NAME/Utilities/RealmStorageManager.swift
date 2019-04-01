//
//  RealmStorageManager.swift
//  NAME
//
//  Created by E-Liang Tan on 29/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import RealmSwift

private let deleteRealmIfMigrationNeeded = true

class RealmStorageManager: StorageManager {
    static let shared = RealmStorageManager()

    private let realm: Realm = {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: deleteRealmIfMigrationNeeded)
        do {
            let realm = try Realm(configuration: realmConfig)
            return realm
        } catch {
            fatalError("Could not initialize Realm due to error \(error)")
        }
    }()

    private init() {
    }

    func writeTransaction(_ block: ((StorageManager) throws -> Void)) throws {
        try realm.write { [unowned self] in
            try block(self)
        }
    }

    func clearData() {
        realm.deleteAll()
    }

    func add<T: Storable>(_ object: T, update: Bool) {
        realm.add(object, update: update)
    }

    func add<S: Sequence>(objects: S, update: Bool) where S.Element: Storable {
        realm.add(objects, update: update)
    }

    func allEstablishments() -> [Establishment] {
        return Array(realm.objects(Establishment.self))
    }
}
