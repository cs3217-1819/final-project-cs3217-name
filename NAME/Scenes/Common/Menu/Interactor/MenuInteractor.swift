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

// MARK: Intrascene interactor IO

protocol MenuInteractorInput: MenuViewControllerOutput {
}

protocol MenuInteractorOutput {
    func present(stall: Stall?)
    func present(actions: [MenuCategoryAction], forCategoryAt index: Int, name: String)
}

final class MenuInteractor: MenuFromParentInput {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    private let output: MenuInteractorOutput
    private let worker: MenuWorker
    private weak var toParentMediator: MenuToParentOutput?

    var stall: Stall? {
        didSet {
            output.present(stall: stall)
        }
    }

    // MARK: - Initializers

    init(stallId: String?,
         output: MenuInteractorOutput,
         injector: DependencyInjector,
         toParentMediator: MenuToParentOutput?,
         worker: MenuWorker = MenuWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
        self.toParentMediator = toParentMediator

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
extension MenuInteractor: MenuViewControllerOutput {
    // MARK: Menu item actions

    func add(menuItemIds: [String], toCategory categoryIndex: Int) {
        guard let menu = stall?.menu else {
            return
        }

        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            menu.add(menuItemIds: menuItemIds, toCategory: categoryIndex)
        }
        output.present(stall: stall)
    }

    func remove(menuItemIds: [String], fromCategory categoryIndex: Int) {
        guard let menu = stall?.menu else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            menu.remove(menuItemIds: menuItemIds, fromCategory: categoryIndex)
        }
        output.present(stall: stall)
    }

    // MARK: Category actions

    func getLegalActions(forCategoryAt index: Int) {
        guard let category = stall?.menu?.categories[index] else {
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
        guard let menu = stall?.menu else {
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
        guard let category = stall?.menu?.categories[index] else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { _ in
            category.name = name
        }
        reload()
    }

    func remove(categoryAt index: Int) {
        guard let menu = stall?.menu else {
            return
        }
        // TODO handle error
        try? deps.storageManager.writeTransaction { manager in
            manager.delete(menu.categories[index])
        }
        reload()
    }

    // MARK: Reload

    func reload() {
        output.present(stall: stall)
    }
}

// MARK: - Dependency injection
extension DependencyInjector {
    fileprivate func dependencies() -> MenuInteractor.Dependencies {
        return MenuInteractor.Dependencies(storageManager: storageManager)
    }
}
