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
        let options = optionValues.map { optionValue -> MenuAddonsViewModel.MenuOptionTypeViewModel in
            switch optionValue.option.options {
            case .boolean(let price):
                let choices: [(name: String, price: String)] =
                    MenuAddonsConstants.booleanChoices.map { arg in
                        let (key, value) = arg
                        return (name: value, price: (key ? price : 0).formattedAsPrice())
                    }
                return .choices(choices)
            case .multipleChoice(let choices):
                return .choices(choices.map { (name: $0.name, price: $0.price.formattedAsPrice()) })
            case .quantity(let price):
                return .quantity(price: price.formattedAsPrice())
            }
        }
        let values = optionValues.map { optionValue -> MenuAddonsViewModel.MenuOptionValueViewModel in
            switch optionValue.value {
            case let .boolean(value):
                guard let choice = MenuAddonsConstants.booleanChoices[value] else {
                    fatalError("You dumbo! Check MenuAddonsConstants.booleanChoices that it maps all boolean!")
                }
                return .choice(choice)
            case let .multipleChoice(value):
                return .choice(value)
            case let .quantity(quantity):
                return .quantity(quantity)
            }
        }
        let optionsViewModel = zip(optionValues, zip(options, values))
            .map { optionValue, arg -> MenuAddonsViewModel.MenuOptionViewModel in
                let (option, value) = arg
                return MenuAddonsViewModel.MenuOptionViewModel(name: optionValue.option.name,
                                                               type: option,
                                                               value: value)
            }
        let viewModel = MenuAddonsViewModel(options: optionsViewModel,
                                            totalPrice: (totalPrice * quantity).formattedAsPrice(),
                                            quantity: quantity)
        output.display(viewModel: viewModel)
    }
}
