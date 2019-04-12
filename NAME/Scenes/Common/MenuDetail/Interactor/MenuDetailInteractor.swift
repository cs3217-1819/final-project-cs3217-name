//
//  MenuDetailInteractor.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuDetailInteractorInput: MenuDetailViewControllerOutput {

}

protocol MenuDetailInteractorOutput {
}

final class MenuDetailInteractor {
    let output: MenuDetailInteractorOutput
    let worker: MenuDetailWorker

    // MARK: - Initializers
    init(output: MenuDetailInteractorOutput, worker: MenuDetailWorker = MenuDetailWorker()) {
        self.output = output
        self.worker = worker
    }
}

// MARK: - MenuDetailInteractorInput
extension MenuDetailInteractor: MenuDetailViewControllerOutput {
}
