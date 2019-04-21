//
//  StorageManager+Extensions.swift
//  NAMETests
//
//  Created by Julius on 21/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
@testable import NAME

// Make all functions optional to facilitate testing
class TestStorageManager: StorageManager {
    func getEstablishment(id: String) -> Establishment? {
        return nil
    }

    func getStall(id: String) -> Stall? {
        return nil
    }

    func writeTransaction(_ block: ((StorageManager) throws -> Void)) throws {
        try block(self)
    }

    func clearData() {
    }

    func add<T>(_ object: T, update: Bool) where T: Storable {
    }

    func add<S>(objects: S, update: Bool) where S: Sequence, S.Element: Storable {
    }

    func delete<T>(_ object: T) where T: Storable {

    }

    func allEstablishments() -> [Establishment] {
        return []
    }

    func allOrders() -> [Order] {
        return []
    }

    func getOrder(id: String) -> Order? {
        return nil
    }

    func getMenuEditable(id: String) -> MenuEditable? {
        return nil
    }

    func getMenuDisplayable(id: String) -> MenuDisplayable? {
        return nil
    }

    func getQueueNumber() -> Int {
        return 0
    }

    func getAccount(username: String) -> Account? {
        return nil
    }
}
