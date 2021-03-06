//
//  StallListRouter.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallListRouterProtocol {
    var viewController: StallListViewController? { get }

    func navigateToStallSettings(withId id: String)
    func navigateToError(title: String, message: String, buttonText: String?)
}

final class StallListRouter {
    weak var viewController: StallListViewController?

    // MARK: - Initializers
    init(viewController: StallListViewController?) {
        self.viewController = viewController
    }
}

// MARK: - StallListRouterProtocol

extension StallListRouter: StallListRouterProtocol {
    func navigateToStallSettings(withId id: String) {
        let settingsVC = AdminSettingsViewController(id: id, type: .stall, isDismissibleView: true)
        viewController?.present(settingsVC, animated: true)
    }

    func navigateToError(title: String, message: String, buttonText: String?) {
        let errorVC = CustomAlertViewController(withTitle: title,
                                                withMessage: message,
                                                buttonText: nil,
                                                alertType: .error)
        viewController?.present(errorVC, animated: true, completion: nil)
    }
}
