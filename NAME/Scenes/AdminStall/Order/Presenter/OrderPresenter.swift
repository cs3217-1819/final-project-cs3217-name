//
//  OrderPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 10/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol OrderPresenterInput: OrderInteractorOutput {

}

protocol OrderPresenterOutput: class {
    func displayOrder(viewModel: OrderViewModel)
}

final class OrderPresenter {
    private(set) unowned var output: OrderPresenterOutput

    // MARK: - Initializers
    init(output: OrderPresenterOutput) {
        self.output = output
    }
}

// MARK: - OrderPresenterInput
extension OrderPresenter: OrderPresenterInput {
    func presentOrder(orderId: String,
                      queueNumber: Int,
                      preparedOrderItems: [OrderItem],
                      unpreparedOrderItems: [OrderItem]) {
        let viewModel =
            OrderViewModel(id: orderId,
                           preparedOrderItems: generateOrderItemViewModels(forOrderItems: preparedOrderItems),
                           unpreparedOrderItems: generateOrderItemViewModels(forOrderItems: unpreparedOrderItems))
        output.displayOrder(viewModel: viewModel)
    }

    private func generateOrderItemViewModels(forOrderItems orderItems: [OrderItem])
        -> [OrderViewModel.OrderItemViewModel] {
        return orderItems.map {
            OrderViewModel.OrderItemViewModel(name: $0.menuItem?.name ?? "",
                                              quantity: String($0.quantity),
                                              diningOption: formatDiningOption($0.diningOption),
                                              options: generateOrderItemOptionsString(Array($0.options)),
                                              addons: $0.addons
                                                .compactMap { $0.name }
                                                .joined(separator: "\n"),
                                              comment: $0.comment)
        }
    }

    private func generateOrderItemOptionsString(_ options: [OrderItemOption]) -> String {
        let optionStrings = options.compactMap { option -> String? in
            let quantity = 1
            guard let optionTitle = option.menuItemOption?.name else {
                assertionFailure("Your menu item option does not exist!")
                return nil
            }
            switch option.value {
            case .boolean(false), .quantity(0), .multipleResponse([]):
                return nil
            case .boolean(true):
                return formatOptionString(quantity: quantity, optionTitle: optionTitle)
            case .quantity(let newQuantity):
                return formatOptionString(quantity: newQuantity, optionTitle: optionTitle)
            case .multipleChoice(let choiceIndex):
                guard case let .multipleChoice(choices)? = option.menuItemOption?.options else {
                    return nil
                }
                return formatOptionString(quantity: quantity,
                                          optionTitle: optionTitle,
                                          choice: choices[choiceIndex].name)
            case .multipleResponse(let selectedChoices):
                guard case let .multipleResponse(choices)? = option.menuItemOption?.options else {
                    return nil
                }
                return selectedChoices.map {
                    formatOptionString(quantity: quantity,
                                       optionTitle: optionTitle,
                                       choice: choices[$0].name)
                }.joined(separator: "\n")
            }
        }
        return optionStrings.joined(separator: "\n")
    }

    private func formatOptionString(quantity: Int, optionTitle: String, choice: String?=nil) -> String {
        guard let choice = choice else {
            return "\(quantity)x \(optionTitle)"
        }
        return "\(quantity)x \(optionTitle): \(choice)"
    }

    private func formatDiningOption(_ diningOption: OrderItem.DiningOption) -> String {
        switch diningOption {
        case .eatin:
            return OrderConstants.eatInDiningOptionTitle
        case .takeaway:
            return OrderConstants.takeAwayDiningOptionTitle
        }
    }
}
