//
//  CustomerRootPresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 25/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomerRootPresenterInput: CustomerRootInteractorOutput {
}

protocol CustomerRootPresenterOutput: class {
    func endSession()
}

final class CustomerRootPresenter {

    private(set) unowned var output: CustomerRootPresenterOutput

    init(output: CustomerRootPresenterOutput) {
        self.output = output
    }
}

// MARK: - CustomerRootPresenterInput

extension CustomerRootPresenter: CustomerRootPresenterInput {
    func endSession() {
        output.endSession()
    }
}
