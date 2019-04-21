//
//  MenuDetailInteractor.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuDetailInteractorInput: MenuDetailViewControllerOutput {

}

protocol MenuDetailInteractorOutput {
}

final class MenuDetailInteractor {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    let output: MenuDetailInteractorOutput
    let worker: MenuDetailWorker
    private let toChildrenMediator: MenuDetailIntersceneMediator

    let menuId: String

    // MARK: - Initializers
    init(output: MenuDetailInteractorOutput,
         menuId: String?,
         injector: DependencyInjector,
         toChildrenMediator: MenuDetailIntersceneMediator,
         worker: MenuDetailWorker = MenuDetailWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.toChildrenMediator = toChildrenMediator
        self.worker = worker

        if let menuId = menuId {
            self.menuId = menuId
        } else {
            let menuItem = IndividualMenuItem(name: MenuDetailConstants.defaultMenuItemName, price: 0)
            try? deps.storageManager.writeTransaction { manager in
                manager.add(menuItem, update: true)
            }
            self.menuId = menuItem.id
        }
    }
}

// MARK: - MenuDetailInteractorInput
extension MenuDetailInteractor: MenuDetailViewControllerOutput {
}

// MARK: - Dependency Injection

extension DependencyInjector {
    fileprivate func dependencies() -> MenuDetailInteractor.Dependencies {
        return MenuDetailInteractor.Dependencies(storageManager: storageManager)
    }
}
