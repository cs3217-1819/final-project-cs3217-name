//
//  EstablishmentRootPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol EstablishmentRootPresenterInput: EstablishmentRootInteractorOutput {
}

protocol EstablishmentRootPresenterOutput: class {
    func display(estId: String)
    func displayLogout()
}

final class EstablishmentRootPresenter {
    private(set) unowned var output: EstablishmentRootPresenterOutput

    // MARK: - Initializers
    init(output: EstablishmentRootPresenterOutput) {
        self.output = output
    }
}

// MARK: - EstablishmentRootPresenterInput
extension EstablishmentRootPresenter: EstablishmentRootPresenterInput {
    func present(estId: String) {
        output.display(estId: estId)
    }

    func presentLogout() {
        output.displayLogout()
    }
}
