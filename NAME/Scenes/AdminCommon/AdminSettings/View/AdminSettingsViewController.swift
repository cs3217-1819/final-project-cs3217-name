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
    func reload()
    func update(name: String?, location: String?, details: String?)
}

final class AdminSettingsViewController: UITableViewController {
    private var tableViewDataSource: AdminSettingsDataSource? {
        didSet {
            tableViewDataSource?.delegate = self
            tableView.dataSource = tableViewDataSource
            tableView.reloadData()
        }
    }

    var output: AdminSettingsViewControllerOutput?
    var router: AdminSettingsRouterProtocol?

    private let footerView: AdminSettingsFooterView

    private var updatedName: String?
    private var updatedLocation: String?
    private var updatedDetails: String?

    // MARK: - Initializers
    init(id: String,
         type: SettingsType,
         isDismissibleView: Bool,
         configurator: AdminSettingsConfigurator = AdminSettingsConfigurator.shared) {
        // Set frame of footer view with non-zero height so that buttons can received taps.
        footerView = AdminSettingsFooterView(frame: CGRect(x: 0, y: 0, width: 0,
                                                          height: ButtonConstants.mediumButtonHeight * 2),
                                             isCancelShown: isDismissibleView)

        super.init(nibName: nil, bundle: nil)
        configure(id: id, type: type, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be called without Storyboard.")
    }

    private func configure(id: String,
                           type: SettingsType,
                           configurator: AdminSettingsConfigurator = AdminSettingsConfigurator.shared) {
        configurator.configure(id: id, type: type, viewController: self)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        footerView.delegate = self
        setupTableView()
        output?.reload()
    }

    private func setupTableView() {
        tableView.backgroundColor = UIColor.Custom.paleGray
        tableView.delegate = self
        tableView.register(AdminSettingsCell.self,
                           forCellReuseIdentifier: ReuseIdentifiers.settingsCellIdentifier)
        tableView.tableFooterView = footerView
    }
}

private class AdminSettingsDataSource: NSObject, UITableViewDataSource {
    private let header: String
    private let cellViewModels: [AdminSettingsViewModel.SettingsFieldViewModel]

    weak var delegate: AdminSettingsCellDelegate?

    init(viewModel: AdminSettingsViewModel) {
        cellViewModels = viewModel.fields
        header = viewModel.header
        super.init()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.settingsCellIdentifier,
                                                 for: indexPath)

        guard let fieldCell = cell as? AdminSettingsCell else {
            assertionFailure("Invalid admin settings table view cell.")
            return cell
        }
        let viewModel = cellViewModels[indexPath.row]
        fieldCell.set(title: viewModel.title, fieldPlaceholer: viewModel.placeholder, type: viewModel.type)
        fieldCell.delegate = delegate
        fieldCell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? header : nil
    }
}

// MARK: - AdminSettingsCellDelegate
extension AdminSettingsViewController: AdminSettingsCellDelegate {
    func newInput(_ input: String?, for fieldType: AdminSettingsViewModel.FieldType) {
        switch fieldType {
        case .name:
            updatedName = input
        case .location:
            updatedLocation = input
        case .details:
            updatedDetails = input
        }
    }
}

// MARK: - AdminSettingsFooterViewDelegate
extension AdminSettingsViewController: AdminSettingsFooterViewDelegate {
    func saveButtonDidTap() {
        output?.update(name: updatedName, location: updatedLocation, details: updatedDetails)
    }

    func cancelButtonDidTap() {
        router?.navigateBack()
    }
}

// MARK: - AdminSettingsPresenterOutput
extension AdminSettingsViewController: AdminSettingsViewControllerInput {
    // TODO: Combine all to one display func
    func display(viewModel: AdminSettingsViewModel) {
        tableViewDataSource = AdminSettingsDataSource(viewModel: viewModel)
    }

}
