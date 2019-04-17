//
//  MenuInfoInteractor.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

// MARK: Interscene interactor IO

protocol MenuInfoFromParentInput: class {
}

protocol MenuInfoToParentOutput: class {
    func set(comment: String)
    var menuInfoInteractor: MenuInfoFromParentInput? { get set }
}

// MARK: Intrascene interactor IO

protocol MenuInfoInteractorInput: MenuInfoViewControllerOutput {

}

protocol MenuInfoInteractorOutput {
    func presentMenuDisplayable(_ menuDisplayable: MenuDisplayable)
    func presentComment(_ comment: String)
}

final class MenuInfoInteractor: MenuInfoFromParentInput {
    fileprivate struct Dependencies {
        let storageManager: StorageManager
    }
    private let deps: Dependencies

    private let output: MenuInfoInteractorOutput
    private let worker: MenuInfoWorker
    private weak var toParentMediator: MenuInfoToParentOutput?

    private var comment: String = "" {
        didSet {
            toParentMediator?.set(comment: comment)
        }
    }

    private let menuDisplayable: MenuDisplayable

    // MARK: - Initializers

    init(output: MenuInfoInteractorOutput,
         menuId: String,
         injector: DependencyInjector = appDefaultInjector,
         toParentMediator: MenuInfoToParentOutput?,
         worker: MenuInfoWorker = MenuInfoWorker()) {
        self.deps = injector.dependencies()
        self.output = output
        self.worker = worker
        self.toParentMediator = toParentMediator
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
