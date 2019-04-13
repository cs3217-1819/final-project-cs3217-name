//
//  KitchenBacklogInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol KitchenBacklogFromChildrenInput: class {
    func handleAllOrderItemsReady()
}

protocol KitchenBacklogToChildrenOutput: class {
    var kitchenBacklogInteractor: KitchenBacklogFromChildrenInput? { get set }
}

// MARK: Intrascene interactor IO

protocol KitchenBacklogInteractorInput: KitchenBacklogViewControllerOutput {
}

protocol KitchenBacklogInteractorOutput {
    func presentOrders(preparedOrders: [Order], unpreparedOrders: [Order])
}

final class KitchenBacklogInteractor: KitchenBacklogFromChildrenInput {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    let output: KitchenBacklogInteractorOutput
    let worker: KitchenBacklogWorker
    private let toChildrenMediator: KitchenBacklogIntersceneMediator

    private var loadedPreparedOrders: [Order] = []
    private var loadedUnpreparedOrders: [Order] = []

    // MARK: - Initializers
    init(output: KitchenBacklogInteractorOutput,
         injector: DependencyInjector,
         toChildrenMediator: KitchenBacklogIntersceneMediator,
         worker: KitchenBacklogWorker = KitchenBacklogWorker()) {
        self.deps = injector.dependencies()
        self.toChildrenMediator = toChildrenMediator
        self.output = output
        self.worker = worker
    }

    func handleAllOrderItemsReady() {
        refreshOrders()
    }
}

// MARK: - KitchenBacklogInteractorInput
extension KitchenBacklogInteractor: KitchenBacklogViewControllerOutput {
    func reloadOrders() {
        // TODO: refreshOrders should be the same as reload orders. But before the network is set up to
        // receive orders, this method will be used to mark all orders as received for now.
        let orders = deps.storageManager.allOrders()
        try? deps.storageManager.writeTransaction { _ in
            orders.forEach { $0.orderItems
                    .forEach { $0.orderHistories.append( OrderHistory(state: .received, timestamp: Date()) ) }
            }
        }
        refreshOrders()
    }

    func refreshOrders() {
        let orders = deps.storageManager.allOrders()
        loadedPreparedOrders = orders.filter { $0.isOrderReady }
        loadedUnpreparedOrders = orders.filter { !$0.isOrderReady && !$0.isOrderCompleted }
        output.presentOrders(preparedOrders: loadedPreparedOrders,
                             unpreparedOrders: loadedUnpreparedOrders)
    }

    func handleOrderCompleted(at index: Int) {
        let order = loadedPreparedOrders[index]
        try? deps.storageManager.writeTransaction { _ in
            order.readyStateOrderItems
                .forEach { $0.orderHistories.append(OrderHistory(state: .completed, timestamp: Date())) }
        }
        refreshOrders()
    }

    func handleOrderReady(at index: Int) {
        let order = loadedUnpreparedOrders[index]
        try? deps.storageManager.writeTransaction { _ in
            order.receivedStateOrderItems
                .forEach { $0.orderHistories.append(OrderHistory(state: .ready, timestamp: Date())) }
        }
        refreshOrders()
    }
}

// MARK: - Dependency injection
extension DependencyInjector {
    fileprivate func dependencies() -> KitchenBacklogInteractor.Dependencies {
        return KitchenBacklogInteractor.Dependencies(storageManager: storageManager)
    }
}
