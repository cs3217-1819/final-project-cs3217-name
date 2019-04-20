//
//  CustomAlertInteractor.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomAlertInteractorInput: CustomAlertViewControllerOutput {

}

protocol CustomAlertInteractorOutput {
}

final class CustomAlertInteractor {
    let output: CustomAlertInteractorOutput
    let worker: CustomAlertWorker

    // MARK: - Initializers
    init(output: CustomAlertInteractorOutput, worker: CustomAlertWorker = CustomAlertWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - CustomAlertInteractorInput
extension CustomAlertInteractor: CustomAlertViewControllerOutput {
}
