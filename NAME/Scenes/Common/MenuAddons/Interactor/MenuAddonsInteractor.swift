//
//  MenuAddonsInteractor.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol MenuAddonsFromParentInput: class {
    func set(comment: String)
    func set(price: Int)
}

protocol MenuAddonsToParentOutput: class {
    var menuAddonsInteractor: MenuAddonsFromParentInput? { get set }
}

// MARK: Intrascene interactor IO

protocol MenuAddonsInteractorInput: MenuAddonsViewControllerOutput {

}

protocol MenuAddonsInteractorOutput {
    func present(optionValues: [MenuAddonsInteractor.OptionValue], basePrice: Int, quantity: Int,
                 addOns: [IndividualMenuItem], selectedAddonsIndices: Set<Int>)
}

final class MenuAddonsInteractor: MenuAddonsFromParentInput {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
        let shoppingCart: ShoppingCart
    }
    private let deps: Dependencies

    struct OptionValue {
        let option: MenuItemOption
        var value: OrderItemOptionValue
    }

    private let output: MenuAddonsInteractorOutput
    private let worker: MenuAddonsWorker
    private weak var toParentMediator: MenuAddonsToParentOutput?

    private let addOns: [IndividualMenuItem]
    private var selectedAddonsIndices: Set<Int> = []
    private var optionValues: [OptionValue]
    private var basePrice: Int
    private var quantity: Int = 1
    private var menuItem: IndividualMenuItem?

    private var comment: String = ""

    // MARK: - Initializers
    init(output: MenuAddonsInteractorOutput,
         menuId: String,
         injector: DependencyInjector = appDefaultInjector,
         toParentMediator: MenuAddonsToParentOutput?,
         worker: MenuAddonsWorker = MenuAddonsWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
        self.toParentMediator = toParentMediator
        guard let menuDisplayable = deps.storageManager.getMenuDisplayable(id: menuId) else {
            fatalError("Initialising MenuAddonsInteractor with non-existent menu id")
        }
        optionValues = menuDisplayable.options.map { OptionValue(option: $0, value: $0.defaultValue) }
        basePrice = menuDisplayable.price
        if let individualMenuItem = menuDisplayable as? IndividualMenuItem {
            addOns = Array(individualMenuItem.addOns)
            menuItem = individualMenuItem
        } else {
            addOns = []
        }
    }

    func set(comment: String) {
        self.comment = comment
    }

    func set(price: Int) {
        basePrice = price
        passValueToPresenter()
    }
}

// MARK: - MenuAddonsInteractorInput
extension MenuAddonsInteractor: MenuAddonsViewControllerOutput {
    func addOption(type: MenuItemOptionType.MetaType, name: String, price: String?) {
        guard name != "", let menuItem = menuItem else {
            return
        }
        let menuItemOption: MenuItemOption
        switch type {
        case .boolean:
            guard let price = price?.asPriceInt() else {
                return
            }
            menuItemOption = MenuItemOption(name: name, options: .boolean(price: price), defaultValue: .boolean(false))
        case .quantity:
            guard let price = price?.asPriceInt() else {
                return
            }
            menuItemOption = MenuItemOption(name: name, options: .quantity(price: price), defaultValue: .quantity(0))
        case .multipleChoice:
            menuItemOption = MenuItemOption(name: name, options: .multipleChoice([]), defaultValue: .multipleChoice(-1))
        case .multipleResponse:
            menuItemOption = MenuItemOption(name: name, options: .multipleResponse([]), defaultValue: .multipleResponse([]))
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { manager in
            manager.add(menuItemOption, update: false)
            menuItem.options.insert(menuItemOption, at: 0)
        }
        optionValues.insert(OptionValue(option: menuItemOption, value: menuItemOption.defaultValue), at: 0)
        passValueToPresenter()
    }

    func addChoice(section: Int, name: String, price: String) {
        guard name != "", let price = price.asPriceInt() else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            switch optionValues[section].option.options {
            case var .multipleChoice(choices):
                if choices.isEmpty {
                    optionValues[section].option.defaultValue = .multipleChoice(0)
                    optionValues[section].value = .multipleChoice(0)
                }
                choices.append((name: name, price: price))
                optionValues[section].option.options = .multipleChoice(choices)
            case var .multipleResponse(choices):
                choices.append((name: name, price: price))
                optionValues[section].option.options = .multipleResponse(choices)
            default:
                break
            }
        }
        passValueToPresenter()
    }

    func finalizeOrderItem(diningOption: OrderItem.DiningOption) {
        // TODO handle SetMenuItem
        guard let menuItem = menuItem else {
            return
        }
        let orderItem = OrderItem(order: nil, menuItem: menuItem, quantity: quantity, comment: comment, diningOption: diningOption)
        deps.shoppingCart.addOrderItem(orderItem)
    }

    func updateQuantity(_ quantity: Int) {
        self.quantity = quantity
        passValueToPresenter()
    }

    func updateValue(at index: Int, with valueIndexOrQuantity: Int) {
        if index < optionValues.count {
            updateOptionValue(at: index, with: valueIndexOrQuantity)
        } else {
            updateAddons(with: valueIndexOrQuantity)
        }
    }

    func updateOptionValue(at index: Int, with valueIndexOrQuantity: Int) {
        switch optionValues[index].option.options {
        case .boolean:
            let boolean = MenuAddonsConstants.booleanChoices[valueIndexOrQuantity]
            optionValues[index].value = .boolean(boolean)
        case .quantity:
            optionValues[index].value = .quantity(valueIndexOrQuantity)
        case .multipleChoice:
            optionValues[index].value = .multipleChoice(valueIndexOrQuantity)
        case .multipleResponse:
            if case var .multipleResponse(choices) = optionValues[index].value {
                if choices.contains(valueIndexOrQuantity) {
                    choices.remove(valueIndexOrQuantity)
                } else {
                    choices.insert(valueIndexOrQuantity)
                }
                optionValues[index].value = .multipleResponse(choices)
            }
        }
        passValueToPresenter()
    }

    func updateAddons(with valueIndex: Int) {
        if selectedAddonsIndices.contains(valueIndex) {
            selectedAddonsIndices.remove(valueIndex)
        } else {
            selectedAddonsIndices.insert(valueIndex)
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
        output.present(optionValues: optionValues,
                       basePrice: basePrice,
                       quantity: quantity,
                       addOns: addOns,
                       selectedAddonsIndices: selectedAddonsIndices)
    }
}

// MARK: - Dependency Injection

extension DependencyInjector {
    fileprivate func dependencies() -> MenuAddonsInteractor.Dependencies {
        return MenuAddonsInteractor.Dependencies(storageManager: storageManager, shoppingCart: shoppingCart)
    }
}
