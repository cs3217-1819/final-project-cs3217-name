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
    func reloadChildren()
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
        output?.reloadChildren()
    }
}

// MARK: - BrowsePresenterOutput

extension BrowseViewController: BrowseViewControllerInput {
    func displayChildren(estId: String) {
        guard let router = router else {
            print("Router required to get child VCs")
            return
        }

        viewControllers = [
            router.stallListViewController(withId: estId),
            router.menuViewController()
        ]
    }
}
