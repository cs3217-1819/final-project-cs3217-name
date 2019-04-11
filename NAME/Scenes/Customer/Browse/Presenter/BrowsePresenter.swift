//
//  BrowsePresenter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol BrowsePresenterInput: BrowseInteractorOutput {
}

protocol BrowsePresenterOutput: class {
}

final class BrowsePresenter {
    private(set) unowned var output: BrowsePresenterOutput

    init(output: BrowsePresenterOutput) {
        self.output = output
    }
}

// MARK: - BrowsePresenterInput

extension BrowsePresenter: BrowsePresenterInput {
}
