//
//  MenuAddonsInteractor.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuAddonsInteractorInput: MenuAddonsViewControllerOutput {

}

protocol MenuAddonsInteractorOutput {
    func present(optionValues: [MenuAddonsInteractor.OptionValue], totalPrice: Int)
}

final class MenuAddonsInteractor {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    struct OptionValue {
        let option: MenuItemOption
        var value: OrderItemOptionValue
    }

    let output: MenuAddonsInteractorOutput
    let worker: MenuAddonsWorker

    private var optionValues: [OptionValue]
    private let basePrice: Int

    // MARK: - Initializers
    init(output: MenuAddonsInteractorOutput,
         menuId: String,
         injector: DependencyInjector = appDefaultInjector,
         worker: MenuAddonsWorker = MenuAddonsWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
        guard let menuDisplayable = deps.storageManager.getMenuDisplayable(id: menuId) else {
            fatalError("Initialising MenuAddonsInteractor with non-existent menu id")
        }
        optionValues = menuDisplayable.options.map { OptionValue(option: $0, value: $0.defaultValue) }
        basePrice = menuDisplayable.price
    }
}

// MARK: - MenuAddonsInteractorInput
extension MenuAddonsInteractor: MenuAddonsViewControllerOutput {
    func updateValue(at index: Int, with valueIndexOrQuantity: Int) {
        switch optionValues[index].option.options {
        case .boolean:
            let boolean = Array(MenuAddonsConstants.booleanChoices.keys)[valueIndexOrQuantity]
            optionValues[index].value = .boolean(boolean)
        case .quantity:
            optionValues[index].value = .quantity(valueIndexOrQuantity)
        case .multipleChoice(let choices):
            let names = choices.map { $0.name }
            optionValues[index].value = .multipleChoice(names[valueIndexOrQuantity])
        }
        passValueToPresenter()
    }

    func reset() {
        optionValues = optionValues.map { OptionValue(option: $0.option, value: $0.option.defaultValue) }
        passValueToPresenter()
    }

    func reset(section: Int) {
        let optionValue = optionValues[section]
        optionValues[section] = OptionValue(option: optionValue.option, value: optionValue.option.defaultValue)
        passValueToPresenter()
    }

    func loadOptions() {
        passValueToPresenter()
    }

    private func passValueToPresenter() {
        let optionPrices = optionValues.map { optionValue -> Int in
            switch (optionValue.option.options, optionValue.value) {
            case let (.boolean(price: price), .boolean(boolean)):
                return boolean ? price : 0
            case let (.quantity(price: price), .quantity(quantity)):
                return price * quantity
            case let (.multipleChoice(choices), .multipleChoice(choice)):
                guard let price = choices.first(where: { $0.name == choice })?.price else {
                    return 0
                }
                return price
            default:
                return 0
            }
        }
        let totalPrice = basePrice + optionPrices.reduce(0, +)
        output.present(optionValues: optionValues, totalPrice: totalPrice)
    }
}

// MARK: - Dependency Injection

extension DependencyInjector {
    fileprivate func dependencies() -> MenuAddonsInteractor.Dependencies {
        return MenuAddonsInteractor.Dependencies(storageManager: storageManager)
    }
}
