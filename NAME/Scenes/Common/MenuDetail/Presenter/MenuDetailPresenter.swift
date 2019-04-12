//
//  MenuDetailPresenter.swift
//  NAME
//
//  Created by Julius on 8/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuDetailPresenterInput: MenuDetailInteractorOutput {

}

protocol MenuDetailPresenterOutput: class {
}

final class MenuDetailPresenter {
    private(set) unowned var output: MenuDetailPresenterOutput

    // MARK: - Initializers
    init(output: MenuDetailPresenterOutput) {
        self.output = output
    }
}

// MARK: - MenuDetailPresenterInput
extension MenuDetailPresenter: MenuDetailPresenterInput {
}
