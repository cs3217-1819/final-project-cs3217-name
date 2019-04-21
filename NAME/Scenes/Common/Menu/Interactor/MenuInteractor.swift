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
