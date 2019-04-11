//
//  StallRootPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallRootPresenterInput: StallRootInteractorOutput {

}

protocol StallRootPresenterOutput: class {
}

final class StallRootPresenter {
    private(set) unowned var output: StallRootPresenterOutput

    // MARK: - Initializers
    init(output: StallRootPresenterOutput) {
        self.output = output
    }
}

// MARK: - StallRootPresenterInput
extension StallRootPresenter: StallRootPresenterInput {
}
