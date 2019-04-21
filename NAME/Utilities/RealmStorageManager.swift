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

    func delete<T: Storable>(_ object: T) {
        realm.delete(object)
    }

    func allEstablishments() -> [Establishment] {
        return Array(realm.objects(Establishment.self))
    }

    func allOrders() -> [Order] {
        return Array(realm.objects(Order.self))
    }

    func getMenuEditable(id: String) -> MenuEditable? {
        let predicate = NSPredicate(format: "id = %@", id)
        // swiftlint:disable first_where
        // Reason for first_where is that Swift is **eager**, hence filter(...).first
        // is more expensive than first(where:)
        // Note that the first(where:) method on Results comes from conformance to Sequence.
        // Using it is worse than performing filter(...).first since Realm is **lazy**.
        let individualMenuItems = realm.objects(IndividualMenuItem.self).filter(predicate).first as MenuEditable?
        let setMenuItems = realm.objects(SetMenuItem.self).filter(predicate).first as MenuEditable?
        // swiftlint:enable first_where
        return [individualMenuItems, setMenuItems].compactMap { $0 }.first
    }

    func getMenuDisplayable(id: String) -> MenuDisplayable? {
        return getMenuEditable(id: id)
    }

    func getOrder(id: String) -> Order? {
        let predicate = NSPredicate(format: "id = %@", id)
        // swiftlint:disable first_where
        return realm.objects(Order.self).filter(predicate).first
        // swiftlint:enable first_where
    }

    func getQueueNumber() -> Int {
        return (realm.objects(Order.self).sorted(byKeyPath: "queueNumber", ascending: true).last?.queueNumber ?? 0) + 1
    }

    func getAccount(username: String) -> Account? {
        let predicate = NSPredicate(format: "username = %@", username)
        // swiftlint:disable first_where
        return realm.objects(Account.self).filter(predicate).first
        // swiftlint:enable first_where
    }
}
