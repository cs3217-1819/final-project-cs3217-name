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
    func loadStall()
    func logout()
}

final class StallRootViewController: UITabBarController {
    var output: StallRootViewControllerOutput?
    var router: StallRootRouterProtocol?

    // MARK: - Initializers
    init(stallId: String, configurator: StallRootConfigurator = StallRootConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator, stallId: stallId)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(configurator: StallRootConfigurator = StallRootConfigurator.shared,
                           stallId: String) {
        configurator.configure(viewController: self, stallId: stallId)
        output?.loadStall()
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setUpTabs(stallId: String) {
        guard let router = router else {
            print("Router required to get child VCs")
            return
        }

        let menuVC = router.menuViewController(stallId: stallId)
        menuVC.title = StallRootConstants.menuTabBarTitle

        let kitchenVC = router.kitchenViewController(stallId: stallId)
        kitchenVC.title = StallRootConstants.kitchenTabBarTitle

        let settingsVC = router.stallSettingsViewController(stallId: stallId)
        settingsVC.title = StallRootConstants.settingsTabBarTitle

        // Dummy view controller that should never be displayed
        // as we should navigate back when the tab is opened.
        let logoutVC = UIViewController()
        logoutVC.title = StallRootConstants.logoutTabBarTitle

        setViewControllers([menuVC, kitchenVC, settingsVC, logoutVC], animated: false)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?.last {
            output?.logout()
        }
    }
}

// MARK: - StallRootPresenterOutput
extension StallRootViewController: StallRootViewControllerInput {
    func display(stallId: String) {
        setUpTabs(stallId: stallId)
    }

    func displayLogout() {
        router?.navigateBack()
    }
}
