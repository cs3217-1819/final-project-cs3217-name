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
    func present(optionValues: [MenuAddonsInteractor.OptionValue], totalPrice: Int, quantity: Int) {
        let optionsViewModel = optionValues.map { optionValue -> MenuAddonsViewModel.MenuOptionViewModel in
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
                                                               type: .choices(choices),
                                                               value: .choice(choiceIndex))
            case let (.multipleChoice(rawChoices), .multipleChoice(choiceIndex)):
                let choices = rawChoices.map { (name: $0.name, price: $0.price.formattedAsPrice()) }
                return MenuAddonsViewModel.MenuOptionViewModel(name: name,
                                                               type: .choices(choices),
                                                               value: .choice(choiceIndex))
            case let (.quantity(price), .quantity(quantity)):
                return MenuAddonsViewModel.MenuOptionViewModel(name: name,
                                                               type: .quantity(price: price.formattedAsPrice()),
                                                               value: .quantity(quantity))
            default:
                fatalError("Inconsistent MenuItemOption's options and defaultValue")
            }
        }
        let viewModel = MenuAddonsViewModel(options: optionsViewModel,
                                            totalPrice: (totalPrice * quantity).formattedAsPrice(),
                                            quantity: quantity)
        output.display(viewModel: viewModel)
    }
}
