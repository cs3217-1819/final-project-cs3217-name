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
    func loadEstablishment()
    func logout()
}

final class EstablishmentRootViewController: UITabBarController {
    var output: EstablishmentRootViewControllerOutput?
    var router: EstablishmentRootRouterProtocol?

    // MARK: - Initializers
    init(estId: String,
         configurator: EstablishmentRootConfigurator = EstablishmentRootConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator, estId: estId)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(configurator: EstablishmentRootConfigurator = EstablishmentRootConfigurator.shared,
                           estId: String) {
        configurator.configure(viewController: self, estId: estId)
        output?.loadEstablishment()
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setUpTabs(estId: String) {
        guard let router = router else {
            print("Router required to get child VCs")
            return
        }

        let stallListVC = router.stallListViewController(estId: estId)
        stallListVC.title = EstablishmentRootConstants.stallListTabBarTitle

        let settingsVC = router.establishmentSettingsViewController(estId: estId)
        settingsVC.title = EstablishmentRootConstants.settingsTabBarTitle

        // Dummy view controller that should never be displayed
        // as we should navigate back when the tab is opened.
        let logoutVC = UIViewController()
        logoutVC.title = EstablishmentRootConstants.logoutTabBarTitle

        setViewControllers([stallListVC, settingsVC, logoutVC], animated: false)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?.last {
            output?.logout()
        }
    }
}

// MARK: - EstablishmentRootPresenterOutput
extension EstablishmentRootViewController: EstablishmentRootViewControllerInput {
    func display(estId: String) {
        setUpTabs(estId: estId)
    }

    func displayLogout() {
        router?.navigateBack()
    }
}
