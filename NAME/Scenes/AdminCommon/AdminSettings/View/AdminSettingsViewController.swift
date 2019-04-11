//
//  AdminSettingsViewController.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsViewControllerInput: AdminSettingsPresenterOutput {

}

protocol AdminSettingsViewControllerOutput {
}

final class AdminSettingsViewController: UIViewController {
    var output: AdminSettingsViewControllerOutput?
    var router: AdminSettingsRouterProtocol?

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleCancelPress(sender:)), for: .touchUpInside)
        button.setTitle("Click to dismiss", for: .normal)
        return button
    }()

    // MARK: - Initializers
    init(configurator: AdminSettingsConfigurator = AdminSettingsConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: AdminSettingsConfigurator = AdminSettingsConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(cancelButton)
        configureConstraints()
    }

    private func configureConstraints() {
        cancelButton.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    @objc
    func handleCancelPress(sender: Any) {
        router?.navigateBack()
    }
}

// MARK: - AdminSettingsPresenterOutput
extension AdminSettingsViewController: AdminSettingsViewControllerInput {
}

extension AdminSettingsViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
