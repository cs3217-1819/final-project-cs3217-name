//
//  MenuInfoInteractor.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuInfoInteractorInput: MenuInfoViewControllerOutput {

}

protocol MenuInfoInteractorOutput {
    func presentMenuDisplayable(_ menuDisplayable: MenuDisplayable)
    func presentComment(_ comment: String)
}

final class MenuInfoInteractor {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    let output: MenuInfoInteractorOutput
    let worker: MenuInfoWorker

    private var comment: String = ""

    private let menuDisplayable: MenuDisplayable

    // MARK: - Initializers

    init(output: MenuInfoInteractorOutput,
         menuId: String,
         injector: DependencyInjector = appDefaultInjector,
         worker: MenuInfoWorker = MenuInfoWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
        guard let menuDisplayable = deps.storageManager.getMenuDisplayable(id: menuId) else {
            fatalError("Initialising MenuInfoInteractor with non-existent menu id")
        }
        self.menuDisplayable = menuDisplayable
    }
}

// MARK: - MenuInfoInteractorInput
extension MenuInfoInteractor: MenuInfoViewControllerOutput {
    func changeComment(_ comment: String) {
        self.comment = comment
        output.presentComment(comment)
    }

    func loadMenuDisplayable() {
        output.presentMenuDisplayable(menuDisplayable)
    }
}

// MARK: - Dependency Injection

extension DependencyInjector {
    fileprivate func dependencies() -> MenuInfoInteractor.Dependencies {
        return MenuInfoInteractor.Dependencies(storageManager: storageManager)
    }
}
