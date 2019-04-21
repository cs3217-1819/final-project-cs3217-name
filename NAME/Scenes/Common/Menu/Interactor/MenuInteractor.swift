//
//  MenuInteractor.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol MenuFromParentInput: class {
    var stall: Stall? { get set }
}

protocol MenuToParentOutput: class {
    var menuInteractor: MenuFromParentInput? { get set }
}

protocol MenuFromChildrenInput: class {
    func handleNewMenuItem(id: String)
}

protocol MenuToChildrenOutput: class {
    var selfInteractor: MenuFromChildrenInput? { get set }
}

// MARK: Intrascene interactor IO

protocol MenuInteractorInput: MenuViewControllerOutput {
}

protocol MenuInteractorOutput {
    func present(stall: Stall?, isEditable: Bool)
    func present(actions: [MenuCategoryAction], forCategoryAt index: Int, name: String)
    func presentDetail(forMenuItemId id: String?, isEditable: Bool)
}

final class MenuInteractor: MenuFromParentInput {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    private let output: MenuInteractorOutput
    private let worker: MenuWorker
    private weak var toParentMediator: MenuToParentOutput?
    private let toChildrenMediator: MenuIntersceneMediator

    var stall: Stall? {
        didSet {
            reload()
        }
    }

    let isEditable: Bool
    var lastCategoryIndexSelected: Int?

    // MARK: - Initializers

    init(stallId: String?,
         isEditable: Bool,
         output: MenuInteractorOutput,
         injector: DependencyInjector,
         toParentMediator: MenuToParentOutput?,
         toChildrenMediator: MenuIntersceneMediator,
         worker: MenuWorker = MenuWorker()) {
        self.deps = injector.dependencies()
        self.isEditable = isEditable
        self.output = output
        self.worker = worker
        self.toParentMediator = toParentMediator
        self.toChildrenMediator = toChildrenMediator

        setStall(withId: stallId)
    }

    private func setStall(withId id: String?) {
        guard let id = id else {
            return
        }
        stall = deps.storageManager.getStall(id: id)
    }
}

// MARK: - MenuInteractorInput
extension MenuInteractor: MenuInteractorInput {
    // MARK: Menu item actions

    func add(menuItemIds: [String], toCategory categoryIndex: Int) {
        guard let menu = stall?.menu, isEditable else {
            return
        }

        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            menu.add(menuItemIds: menuItemIds, toCategory: categoryIndex)
        }
        output.present(stall: stall, isEditable: isEditable)
    }

    func remove(menuItemIds: [String], fromCategory categoryIndex: Int) {
        guard let menu = stall?.menu, isEditable else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            menu.remove(menuItemIds: menuItemIds, fromCategory: categoryIndex)
        }
        output.present(stall: stall, isEditable: isEditable)
    }

    // MARK: Category actions

    func getLegalActions(forCategoryAt index: Int) {
        guard let category = stall?.menu?.categories[index], isEditable else {
            return
        }

        var actions: [MenuCategoryAction] = [.insertLeft]

        if !category.isUncategorized {
            actions.append(.insertRight)
            actions.append(.rename)

            if category.items.isEmpty {
                actions.append(.remove)
            }
        }

        output.present(actions: actions, forCategoryAt: index, name: category.name)
    }

    func insert(newCategoryName: String, besideCategoryAt index: Int, onLeft: Bool) {
        guard let menu = stall?.menu, isEditable else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { manager in
            let category = MenuCategory()
            category.name = newCategoryName
            manager.add(category, update: true)
            menu.add(category: category, at: index + (onLeft ? 0 : 1))
        }
        reload()
    }

    func rename(categoryAt index: Int, to name: String) {
        guard let category = stall?.menu?.categories[index], isEditable else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            category.name = name
        }
        reload()
    }

    func remove(categoryAt index: Int) {
        guard let menu = stall?.menu, isEditable else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            menu.remove(categoryAt: index)
        }
        reload()
    }

    // MARK: Misc

    func select(menuItemId: String?, categoryIndex: Int) {
        lastCategoryIndexSelected = categoryIndex
        output.presentDetail(forMenuItemId: menuItemId, isEditable: isEditable)
    }

    func reload() {
        output.present(stall: stall, isEditable: isEditable)
    }
}

// MARK: - MenuFromChildrenInput
extension MenuInteractor: MenuFromChildrenInput {
    func handleNewMenuItem(id: String) {
        guard let item = deps.storageManager.getMenuEditable(id: id) else {
            print("Could not find created item")
            return
        }

        guard isEditable,
            let menu = stall?.menu,
            let lastCategoryIndexSelected = lastCategoryIndexSelected else {
                return
        }

        try? deps.storageManager.writeTransaction { _ in
            menu.add(newMenuEditable: item)
            menu.add(menuItemIds: [id], toCategory: lastCategoryIndexSelected)
        }

        reload()
    }
}

// MARK: - Dependency injection
extension DependencyInjector {
    fileprivate func dependencies() -> MenuInteractor.Dependencies {
        return MenuInteractor.Dependencies(storageManager: storageManager)
    }
}
