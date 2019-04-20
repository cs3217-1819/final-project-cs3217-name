//
//  EstablishmentRootViewController.swift
//  NAME
//
//  Created by Caryn Heng on 31/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol EstablishmentRootViewControllerInput: EstablishmentRootPresenterOutput {
}

protocol EstablishmentRootViewControllerOutput {

}

final class EstablishmentRootViewController: UITabBarController {
    var output: EstablishmentRootViewControllerOutput?
    var router: EstablishmentRootRouterProtocol?

    // MARK: - Initializers
    init(configurator: EstablishmentRootConfigurator = EstablishmentRootConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: EstablishmentRootConfigurator = EstablishmentRootConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
        setUpTabs()
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setUpTabs() {
        guard let router = router else {
            print("Router required to get child VCs")
            return
        }

        let stallListVC = router.stallListViewController()
        stallListVC.title = EstablishmentRootConstants.stallListTabBarTitle

        let settingsVC = router.establishmentSettingsViewController()
        settingsVC.title = EstablishmentRootConstants.settingsTabBarTitle

        // Dummy view controller that should never be displayed
        // as we should navigate back when the tab is opened.
        let logoutVC = UIViewController()
        logoutVC.title = EstablishmentRootConstants.logoutTabBarTitle

        setViewControllers([stallListVC, settingsVC, logoutVC], animated: false)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?.last {
            router?.navigateBack()
        }
    }
}

// MARK: - EstablishmentRootPresenterOutput
extension EstablishmentRootViewController: EstablishmentRootViewControllerInput {

}

extension EstablishmentRootViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
