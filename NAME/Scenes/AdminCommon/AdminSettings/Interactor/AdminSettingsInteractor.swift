//
//  AdminSettingsInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsInteractorInput: AdminSettingsViewControllerOutput {

}

protocol AdminSettingsInteractorOutput {
    func presentSomething()
}

final class AdminSettingsInteractor {
    let output: AdminSettingsInteractorOutput
    let worker: AdminSettingsWorker

    // MARK: - Initializers
    init(output: AdminSettingsInteractorOutput, worker: AdminSettingsWorker = AdminSettingsWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - AdminSettingsInteractorInput
extension AdminSettingsInteractor: AdminSettingsViewControllerOutput {
    func doSomething() {
        // TODO: Create some Worker to do the work
        worker.doSomeWork()
        // TODO: Pass the result to the Presenter
        output.presentSomething()
    }
}
