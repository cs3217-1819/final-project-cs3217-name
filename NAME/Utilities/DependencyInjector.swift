//
//  DependencyInjector.swift
//  NAME
//
//  Created by E-Liang Tan on 30/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

protocol DependencyInjector {
    var storageManager: StorageManager { get }
    var shoppingCart: ShoppingCart { get }
}

final class ProductionDependencyInjector: DependencyInjector {
    static let shared = ProductionDependencyInjector()

    let storageManager: StorageManager = RealmStorageManager.shared
    private(set) lazy var shoppingCart: ShoppingCart = ProductionShoppingCart(storageManager: storageManager)

    private init() {
    }
}

/// The default dependency injector for the app, for use in development and production.
let appDefaultInjector = ProductionDependencyInjector.shared
