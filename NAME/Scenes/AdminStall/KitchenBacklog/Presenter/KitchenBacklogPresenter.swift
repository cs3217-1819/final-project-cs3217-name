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
    func presentOrders(preparedOrders: [Order], unpreparedOrders: [Order]) {
        let viewModel = KitchenBacklogViewModel(preparedOrders: makeOrderViewModels(forOrders: preparedOrders),
                                                unpreparedOrders: makeOrderViewModels(forOrders: unpreparedOrders))
        output.displayOrders(viewModel: viewModel)
    }

    private func makeOrderViewModels(forOrders orders: [Order]) -> [KitchenBacklogViewModel.OrderViewModel] {
        return orders.map {
            KitchenBacklogViewModel.OrderViewModel(orderId: $0.id,
                                                   title: $0.queueNumber.formattedAsQueueNumberTitle(),
                                                   timeStamp: $0.orderReceivedTimeStamp ?? Date())
        }
    }

}
