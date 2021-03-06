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

    private let isEditable: Bool

    // MARK: - Initializers
    init(output: MenuAddonsInteractorOutput,
         menuId: String,
         isEditable: Bool,
         injector: DependencyInjector = appDefaultInjector,
         toParentMediator: MenuAddonsToParentOutput?,
         worker: MenuAddonsWorker = MenuAddonsWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
        self.isEditable = isEditable
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
    func deleteValue(section: Int, item: Int) {
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            let optionValue = optionValues[section]
            switch (optionValue.option.options, optionValue.option.defaultValue, optionValue.value) {
            case (.multipleChoice(var choices), .multipleChoice(let defaultValue), .multipleChoice(let value)):
                choices.remove(at: item)
                optionValues[section].option.options = .multipleChoice(choices)
                let newDefaultValue = adjustIndex(defaultValue, deletedIndex: item) ?? (choices.count - 1)
                optionValues[section].option.defaultValue = .multipleChoice(newDefaultValue)
                let newValue = adjustIndex(value, deletedIndex: item) ?? (choices.count - 1)
                optionValues[section].value = .multipleChoice(newValue)
            case (.multipleResponse(var choices), .multipleResponse(let defaultValue), .multipleResponse(let value)):
                choices.remove(at: item)
                optionValues[section].option.options = .multipleResponse(choices)
                let newDefaultValue = Set(defaultValue.compactMap { adjustIndex($0, deletedIndex: item) })
                optionValues[section].option.defaultValue = .multipleResponse(newDefaultValue)
                let newValue = Set(value.compactMap { adjustIndex($0, deletedIndex: item) })
                optionValues[section].value = .multipleResponse(newValue)
            default:
                break
            }
            passValueToPresenter()
        }
    }

    private func adjustIndex(_ index: Int, deletedIndex: Int) -> Int? {
        if index == deletedIndex {
            return nil
        } else if index > deletedIndex {
            return index - 1
        }
        return index
    }

    func moveValue(section: Int, fromItem: Int, toItem: Int) {
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            let optionValue = optionValues[section]
            switch (optionValue.option.options, optionValue.option.defaultValue, optionValue.value) {
            case (.multipleChoice(var choices), .multipleChoice(let defaultValue), .multipleChoice(let value)):
                let choice = choices.remove(at: fromItem)
                choices.insert(choice, at: toItem)
                optionValues[section].option.options = .multipleChoice(choices)
                optionValues[section].option.defaultValue =
                    .multipleChoice(adjustIndex(defaultValue, fromItem: fromItem, toItem: toItem))
                optionValues[section].value = .multipleChoice(adjustIndex(value, fromItem: fromItem, toItem: toItem))
            case (.multipleResponse(var choices), .multipleResponse(let defaultValue), .multipleResponse(let value)):
                let choice = choices.remove(at: fromItem)
                choices.insert(choice, at: toItem)
                optionValues[section].option.options = .multipleResponse(choices)
                let newDefaultValue = Set(defaultValue.map { adjustIndex($0, fromItem: fromItem, toItem: toItem) })
                let newValue = Set(value.map { adjustIndex($0, fromItem: fromItem, toItem: toItem) })
                optionValues[section].option.defaultValue = .multipleResponse(newDefaultValue)
                optionValues[section].value = .multipleResponse(newValue)
            default:
                break
            }
        }
        passValueToPresenter()
    }

    private func adjustIndex(_ index: Int, fromItem: Int, toItem: Int) -> Int {
        if index == fromItem {
            return toItem
        } else if index > fromItem && index <= toItem {
            return index - 1
        } else if index < fromItem && index >= toItem {
            return index + 1
        }
        return index
    }

    func reorderUp(section: Int) {
        guard let menuItem = menuItem, section > 0 else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            menuItem.options.swapAt(section, section - 1)
        }
        optionValues.swapAt(section, section - 1)
        passValueToPresenter()
    }

    func reorderDown(section: Int) {
        guard let menuItem = menuItem, section + 1 < optionValues.count else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            menuItem.options.swapAt(section, section + 1)
        }
        optionValues.swapAt(section, section + 1)
        passValueToPresenter()
    }

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
        if isEditable {
            // TODO handle error
            try? deps.storageManager.writeTransaction { _ in
                optionValues[index].option.defaultValue = optionValues[index].value
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
        selectedAddonsIndices = []
        passValueToPresenter()
    }

    func reset(section: Int) {
        if section < optionValues.count {
            let optionValue = optionValues[section]
            optionValues[section] = OptionValue(option: optionValue.option, value: optionValue.option.defaultValue)
        } else {
            selectedAddonsIndices = []
        }
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
