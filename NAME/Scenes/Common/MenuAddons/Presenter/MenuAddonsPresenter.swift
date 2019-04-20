//
//  MenuAddonsPresenter.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuAddonsPresenterInput: MenuAddonsInteractorOutput {

}

protocol MenuAddonsPresenterOutput: class {
    func display(viewModel: MenuAddonsViewModel)
}

final class MenuAddonsPresenter {
    private(set) unowned var output: MenuAddonsPresenterOutput

    // MARK: - Initializers
    init(output: MenuAddonsPresenterOutput) {
        self.output = output
    }
}

// MARK: - MenuAddonsPresenterInput
extension MenuAddonsPresenter: MenuAddonsPresenterInput {
    func present(optionValues: [MenuAddonsInteractor.OptionValue], basePrice: Int, quantity: Int,
                 addOns: [IndividualMenuItem], selectedAddonsIndices: Set<Int>) {
        let totalPrice = calculateTotalPrice(optionValues: optionValues,
                                             addOns: addOns,
                                             selectedAddonsIndices: selectedAddonsIndices,
                                             basePrice: basePrice,
                                             quantity: quantity)
        let optionsViewModel = makeMenuOptionViewModels(fromOptionValues: optionValues) +
            [makeMenuOptionViewModel(fromAddOns: addOns, selectedIndices: selectedAddonsIndices)]
        let viewModel = MenuAddonsViewModel(options: optionsViewModel,
                                            totalPrice: totalPrice,
                                            quantity: quantity)
        output.display(viewModel: viewModel)
    }

    private func makeMenuOptionViewModels(fromOptionValues optionValues: [MenuAddonsInteractor.OptionValue])
        -> [MenuAddonsViewModel.MenuOptionViewModel] {
        return optionValues.map { optionValue -> MenuAddonsViewModel.MenuOptionViewModel in
            let name = optionValue.option.name
            switch (optionValue.option.options, optionValue.value) {
            case let (.boolean(price), .boolean(value)):
                let choices: [(name: String, price: String)] = MenuAddonsConstants.booleanChoices.enumerated()
                    .map { index, choice in
                        return (name: MenuAddonsConstants.booleanChoicesTitle[index],
                                price: (choice ? price : 0).formattedAsPrice())
                    }
                guard let choiceIndex = MenuAddonsConstants.booleanChoices.firstIndex(of: value) else {
                    fatalError("You dumbo! Check that MenuAddonsConstants.booleanChoices contains both true and false")
                }
                return MenuAddonsViewModel.MenuOptionViewModel(name: name,
                                                               type: .choices(choices, isEditable: false),
                                                               value: .choices([choiceIndex]))
            case let (.multipleChoice(rawChoices), .multipleChoice(choiceIndex)):
                let choices = rawChoices.map { (name: $0.name, price: $0.price.formattedAsPrice()) }
                return MenuAddonsViewModel.MenuOptionViewModel(name: name,
                                                               type: .choices(choices, isEditable: true),
                                                               value: .choices([choiceIndex]))
            case let (.quantity(price), .quantity(quantity)):
                return MenuAddonsViewModel.MenuOptionViewModel(name: name,
                                                               type: .quantity(price: price.formattedAsPrice()),
                                                               value: .quantity(quantity))
            case let (.multipleResponse(rawChoices), .multipleResponse(selectedChoices)):
                let choices = rawChoices.map { (name: $0.name, price: $0.price.formattedAsPrice()) }
                return MenuAddonsViewModel.MenuOptionViewModel(name: name,
                                                               type: .choices(choices, isEditable: true),
                                                               value: .choices(selectedChoices))
            default:
                fatalError("Inconsistent MenuItemOption's options and defaultValue")
            }
        }
    }

    private func makeMenuOptionViewModel(fromAddOns addOns: [IndividualMenuItem],
                                         selectedIndices: Set<Int>) -> MenuAddonsViewModel.MenuOptionViewModel {
        let choices = addOns.map { (name: $0.name, price: $0.price.formattedAsPrice()) }
        return MenuAddonsViewModel.MenuOptionViewModel(name: MenuAddonsConstants.addOnsOptionTitle,
                                                       type: .choices(choices, isEditable: false),
                                                       value: .choices(selectedIndices))
    }

    private func calculateTotalPrice(optionValues: [MenuAddonsInteractor.OptionValue],
                                     addOns: [IndividualMenuItem],
                                     selectedAddonsIndices: Set<Int>,
                                     basePrice: Int,
                                     quantity: Int) -> String {
        let optionPrice = optionValues.map { optionValue -> Int in
            switch (optionValue.option.options, optionValue.value) {
            case let (.boolean(price: price), .boolean(boolean)):
                return boolean ? price : 0
            case let (.quantity(price: price), .quantity(quantity)):
                return price * quantity
            case let (.multipleChoice(choices), .multipleChoice(choiceIndex)):
                return choices[choiceIndex].price
            case let (.multipleResponse(choices), .multipleResponse(selectedChoices)):
                return selectedChoices.map { choices[$0].price }.reduce(0, +)
            default:
                return 0
            }
        }.reduce(0, +)
        let addOnsPrice = selectedAddonsIndices.map { addOns[$0].price }.reduce(0, +)
        let priceForOne = basePrice + optionPrice + addOnsPrice
        let totalPrice = priceForOne &* quantity
        guard totalPrice >= 0 else {
            return "🤑"
        }
        return totalPrice.formattedAsPrice()
    }
}
