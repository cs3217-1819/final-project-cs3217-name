//
//  AdminSettingsPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsPresenterInput: AdminSettingsInteractorOutput {

}

protocol AdminSettingsPresenterOutput: class {
}

final class AdminSettingsPresenter {
    private(set) unowned var output: AdminSettingsPresenterOutput

    // MARK: - Initializers
    init(output: AdminSettingsPresenterOutput) {
        self.output = output
    }
}

// MARK: - AdminSettingsPresenterInput
extension AdminSettingsPresenter: AdminSettingsPresenterInput {
}
