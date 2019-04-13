//
//  OrderInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 10/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol OrderFromParentInput: class {
}

protocol OrderToParentOutput: class {
    var orderInteractor: OrderFromParentInput? { get set }
    func handleOrderReady()
}

// MARK: Intrascene interactor IO

protocol OrderInteractorInput: OrderViewControllerOutput {

}

protocol OrderInteractorOutput {
    func presentOrder(orderId: String,
                      queueNumber: Int,
                      preparedOrderItems: [OrderItem],
                      unpreparedOrderItems: [OrderItem])
}

final class OrderInteractor: OrderFromParentInput {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    let output: OrderInteractorOutput
    let worker: OrderWorker
    private weak var toParentMediator: OrderToParentOutput?

    private var loadedOrderId: String
    private var loadedPreparedOrderItems: [OrderItem] = []
    private var loadedUnpreparedOrderItems: [OrderItem] = []

    // MARK: - Initializers
    init(output: OrderInteractorOutput,
         orderId: String,
         injector: DependencyInjector,
         toParentMediator: OrderToParentOutput?,
         worker: OrderWorker = OrderWorker()) {
        deps = injector.dependencies()
        loadedOrderId = orderId
        self.output = output
        self.worker = worker
        self.toParentMediator = toParentMediator
    }
}

// MARK: - OrderInteractorInput
extension OrderInteractor: OrderViewControllerOutput {
    func reloadOrder() {
        guard let order = deps.storageManager.getOrder(id: loadedOrderId) else {
            return
        }
        loadedPreparedOrderItems = order.readyStateOrderItems
        loadedUnpreparedOrderItems = order.receivedStateOrderItems
        output.presentOrder(orderId: loadedOrderId,
                            queueNumber: order.queueNumber,
                            preparedOrderItems: loadedPreparedOrderItems,
                            unpreparedOrderItems: loadedUnpreparedOrderItems)
    }

    func handleOrderItemReady(at index: Int) {
        let orderItem = loadedUnpreparedOrderItems[index]
        try? deps.storageManager.writeTransaction { _ in
            orderItem.orderHistories.append(OrderHistory(state: .ready, timestamp: Date()))
        }

        if loadedUnpreparedOrderItems.count <= 1 {
            toParentMediator?.handleOrderReady()
        } else {
            reloadOrder()
        }
    }
}

// MARK: - Dependency injection
extension DependencyInjector {
    fileprivate func dependencies() -> OrderInteractor.Dependencies {
        return OrderInteractor.Dependencies(storageManager: storageManager)
    }
}
