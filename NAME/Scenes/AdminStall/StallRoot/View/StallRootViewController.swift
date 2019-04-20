//
//  StallRootViewController.swift
//  NAME
//
//  Created by Caryn Heng on 29/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallRootViewControllerInput: StallRootPresenterOutput {

}

protocol StallRootViewControllerOutput {
}

final class StallRootViewController: UITabBarController {
    var output: StallRootViewControllerOutput?
    var router: StallRootRouterProtocol?

    // MARK: - Initializers
    init(configurator: StallRootConfigurator = StallRootConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: StallRootConfigurator = StallRootConfigurator.shared) {
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

        let menuVC = router.menuViewController()
        menuVC.title = StallRootConstants.menuTabBarTitle

        let kitchenVC = router.kitchenViewController()
        kitchenVC.title = StallRootConstants.kitchenTabBarTitle

        let settingsVC = router.stallSettingsViewController()
        settingsVC.title = StallRootConstants.settingsTabBarTitle

        // Dummy view controller that should never be displayed
        // as we should navigate back when the tab is opened.
        let logoutVC = UIViewController()
        logoutVC.title = StallRootConstants.logoutTabBarTitle

        setViewControllers([menuVC, kitchenVC, settingsVC, logoutVC], animated: false)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?.last {
            router?.navigateBack()
        }
    }
}

// MARK: - StallRootPresenterOutput
extension StallRootViewController: StallRootViewControllerInput {
}

extension StallRootViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
