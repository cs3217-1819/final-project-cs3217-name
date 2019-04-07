//
//  KitchenBacklogInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol KitchenBacklogInteractorInput: KitchenBacklogViewControllerOutput {
}

protocol KitchenBacklogInteractorOutput {
    func presentOrders(orders: [Order])
}

final class KitchenBacklogInteractor {
    let output: KitchenBacklogInteractorOutput
    let worker: KitchenBacklogWorker

    private var loadedOrders: [Order] = []

    // MARK: - Initializers
    init(output: KitchenBacklogInteractorOutput, worker: KitchenBacklogWorker = KitchenBacklogWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - KitchenBacklogInteractorInput
extension KitchenBacklogInteractor: KitchenBacklogViewControllerOutput {
    func reloadOrders() {
        loadedOrders = worker.getOrders()
        output.presentOrders(orders: loadedOrders)
    }
}
