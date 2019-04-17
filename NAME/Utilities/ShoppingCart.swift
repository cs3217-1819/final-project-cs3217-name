//
//  ShoppingCart.swift
//  NAME
//
//  Created by Julius on 17/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

protocol ShoppingCart: class {
    func addOrderItem(_ orderItem: OrderItem)

    func createOrder() throws -> Order
}

class ProductionShoppingCart: ShoppingCart {
    private var orderItems: [OrderItem] = []
    private let storageManager: StorageManager

    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }

    func addOrderItem(_ orderItem: OrderItem) {
        orderItems.append(orderItem)
    }

    func createOrder() throws -> Order {
        let queueNumber = storageManager.getQueueNumber()
        // TODO get customer properly
        let customer = Customer()
        let order = Order(queueNumber: queueNumber, customer: customer)
        orderItems.forEach { $0.order = order }
        try storageManager.writeTransaction { manager in
            manager.add(objects: orderItems, update: false)
            manager.add(customer, update: false)
            manager.add(order, update: false)
        }
        return order
    }
}
