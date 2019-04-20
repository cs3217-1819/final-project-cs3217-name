//
//  CustomAlertPresenter.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomAlertPresenterInput: CustomAlertInteractorOutput {

}

protocol CustomAlertPresenterOutput: class {
}

final class CustomAlertPresenter {
    private(set) unowned var output: CustomAlertPresenterOutput

    // MARK: - Initializers
    init(output: CustomAlertPresenterOutput) {
        self.output = output
    }
}

// MARK: - CustomAlertPresenterInput
extension CustomAlertPresenter: CustomAlertPresenterInput {
}
