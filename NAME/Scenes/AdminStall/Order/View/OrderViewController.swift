//
//  OrderViewController.swift
//  NAME
//
//  Created by Caryn Heng on 10/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol OrderViewControllerInput: OrderPresenterOutput {
}

protocol OrderViewControllerOutput {
    func reloadOrder()
    func handleOrderItemReady(at index: Int)
}

final class OrderViewController: UITableViewController {
    var output: OrderViewControllerOutput?
    var router: OrderRouterProtocol?

    private var tableViewDataSource: OrderViewDataSource? {
        didSet {
            tableViewDataSource?.delegate = self
            tableView.dataSource = tableViewDataSource
            tableView.reloadData()
        }
    }

    // MARK: - Initializers
    init(orderId: String,
         mediator: OrderToParentOutput?,
         configurator: OrderConfigurator = OrderConfigurator.shared) {
        super.init(style: .plain)
        configure(orderId: orderId, mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("This should not be called without Storyboard.")
    }

    private func configure(orderId: String,
                           mediator: OrderToParentOutput?,
                           configurator: OrderConfigurator = OrderConfigurator.shared) {
        configurator.configure(orderId: orderId, viewController: self, toParentMediator: mediator)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        output?.reloadOrder()
    }

    private func setupTableView() {
        tableView.backgroundColor = UIColor.Custom.paleGray
        tableView.delegate = self
        tableView.register(OrderItemViewCell.self,
                           forCellReuseIdentifier: ReuseIdentifiers.orderItemCellIdentifier)
        tableView.tableFooterView = UIView() // Necessary to remove extra rows in the tableview
    }
}

// MARK: - OrderItemViewCellDelegate
extension OrderViewController: OrderItemViewCellDelegate {
    func didTapReady(forCell cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            assertionFailure("Cannot locate index path of cell to be deleted.")
            return
        }
        output?.handleOrderItemReady(at: indexPath.row)
    }
}

// MARK: - UITableViewDataSource
private class OrderViewDataSource: NSObject, UITableViewDataSource {
    private struct SectionViewModel {
        let title: String?
        let cellViewModel: [OrderViewModel.OrderItemViewModel]
    }
    private let sectionViewModels: [SectionViewModel]

    weak var delegate: OrderItemViewCellDelegate?

    init(preparedItemViewModels: [OrderViewModel.OrderItemViewModel],
         unpreparedItemViewModels: [OrderViewModel.OrderItemViewModel]) {
        let unpreparedSectionViewModels = SectionViewModel(title: nil, cellViewModel: unpreparedItemViewModels)
        let preparedSectionViewModels = SectionViewModel(title: OrderConstants.preparedItemsSectionTitle,
                                                         cellViewModel: preparedItemViewModels)
        sectionViewModels = [unpreparedSectionViewModels, preparedSectionViewModels]
        super.init()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionViewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionViewModels[section].cellViewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.orderItemCellIdentifier,
                                                 for: indexPath)
        guard let itemCell = cell as? OrderItemViewCell else {
            assertionFailure("Invalid table view cell.")
            return cell
        }
        let viewModel = sectionViewModels[indexPath.section].cellViewModel[indexPath.row]
        itemCell.set(quantity: viewModel.quantity,
                     name: viewModel.name,
                     diningOption: viewModel.diningOption,
                     options: viewModel.options,
                     addons: viewModel.addons,
                     comment: viewModel.comment,
                     isItemPrepared: indexPath.section == 1)
        itemCell.delegate = delegate
        cell.backgroundColor = UIColor.Custom.paleGray
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableView(tableView, numberOfRowsInSection: section) > 0 ?
            sectionViewModels[section].title : nil
    }

}

// MARK: - OrderPresenterOutput
extension OrderViewController: OrderViewControllerInput {
    func displayOrder(viewModel: OrderViewModel) {
        tableViewDataSource = OrderViewDataSource(preparedItemViewModels: viewModel.preparedOrderItems,
                                                  unpreparedItemViewModels: viewModel.unpreparedOrderItems)
    }
}
