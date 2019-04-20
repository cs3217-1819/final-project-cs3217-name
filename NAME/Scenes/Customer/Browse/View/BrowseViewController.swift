//
//  BrowseViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol BrowseViewControllerInput: BrowsePresenterOutput {
}

protocol BrowseViewControllerOutput {
}

final class BrowseViewController: UISplitViewController {
    var output: BrowseViewControllerOutput?
    var router: BrowseRouterProtocol?

    // MARK: - Initializers

    init(toParentMediator: BrowseToParentOutput?,
         configurator: BrowseConfigurator = BrowseConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(toParentMediator: toParentMediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurator

    private func configure(toParentMediator: BrowseToParentOutput?,
                           configurator: BrowseConfigurator = BrowseConfigurator.shared) {
        configurator.configure(toParentMediator: toParentMediator, viewController: self)
        maximumPrimaryColumnWidth = CustomerCommonConstants.primaryWidth
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - BrowsePresenterOutput

extension BrowseViewController: BrowseViewControllerInput {
}
