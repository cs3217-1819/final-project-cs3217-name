//
//  StorageManager.swift
//  NAME
//
//  Created by E-Liang Tan on 29/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import RealmSwift // For Object

typealias Storable = Object

protocol StorageManager {
    func writeTransaction(_ block: ((StorageManager) throws -> Void)) throws

    func clearData()

    func add<T: Storable>(_ object: T, update: Bool)
    func add<S: Sequence>(objects: S, update: Bool) where S.Element: Storable

    func delete<T: Storable>(_ object: T)

    func allEstablishments() -> [Establishment]
    func getEstablishment(id: String) -> Establishment?
    func updateEstablishment(id: String, name: String?, location: String?, details: String?)

    func getStall(id: String) -> Stall?
    func updateStall(id: String, name: String?, location: String?, details: String?)

    func allOrders() -> [Order]
    func getOrder(id: String) -> Order?

    func getMenuEditable(id: String) -> MenuEditable?
    func getMenuDisplayable(id: String) -> MenuDisplayable?

    func getQueueNumber() -> Int

    func getAccount(username: String) -> Account?
}
