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
}
