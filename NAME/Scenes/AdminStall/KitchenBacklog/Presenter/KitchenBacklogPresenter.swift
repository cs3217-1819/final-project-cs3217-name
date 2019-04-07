//
//  KitchenBacklogPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol KitchenBacklogPresenterInput: KitchenBacklogInteractorOutput {
}

protocol KitchenBacklogPresenterOutput: class {
    func displayOrders(viewModel: KitchenBacklogViewModel)
}

final class KitchenBacklogPresenter {
    private(set) unowned var output: KitchenBacklogPresenterOutput

    // MARK: - Initializers
    init(output: KitchenBacklogPresenterOutput) {
        self.output = output
    }
}

// MARK: - KitchenBacklogPresenterInput
extension KitchenBacklogPresenter: KitchenBacklogPresenterInput {
    func presentOrders(orders: [Order]) {
        let orderViewModels = orders.map {
            OrderViewModel(title: KitchenBacklogConstants.orderNumberPrefix + String($0.queueNumber),
                orderItems: $0.orderItems.map {
                    OrderItemViewModel(name: $0.menuItem?.name ?? "",
                                       quantity: $0.menuItem?.quantity ?? 0,
                                       comment: $0.comment)
                })
        }
        let viewModel = KitchenBacklogViewModel(orders: orderViewModels)
        output.displayOrders(viewModel: viewModel)
    }
}
