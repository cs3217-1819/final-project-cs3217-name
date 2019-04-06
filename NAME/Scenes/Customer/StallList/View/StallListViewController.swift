//
//  StallListViewController.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol StallListViewControllerInput: StallListPresenterOutput {

}

protocol StallListViewControllerOutput {
    func reloadStalls()
    func handleStallSelect(at index: Int)
}

final class StallListViewController: UITableViewController {
    private static let stallCellIdentifier = "stallCellIdentifier"

    private class StallListDataSource: NSObject, UITableViewDataSource {
        private let cellViewModels: [StallListViewModel.StallViewModel]

        init(stalls: [StallListViewModel.StallViewModel]) {
            self.cellViewModels = stalls
            super.init()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cellViewModels.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: stallCellIdentifier, for: indexPath)

            let model = cellViewModels[indexPath.row]
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.location

            return cell
        }
    }

    private var tableViewDataSource: StallListDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
            tableView.reloadData()
        }
    }

    var output: StallListViewControllerOutput?
    var router: StallListRouterProtocol?

    // MARK: - Initializers

    init(mediator: StallListToParentOutput?,
         configurator: StallListConfigurator = StallListConfigurator.shared) {
        super.init(style: .plain)
        configure(mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configurator

    private func configure(mediator: StallListToParentOutput?,
                           configurator: StallListConfigurator = StallListConfigurator.shared) {
        configurator.configure(viewController: self, toParentMediator: mediator)

        tableView.register(StallListTableViewCell.self,
                           forCellReuseIdentifier: StallListViewController.stallCellIdentifier)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.reloadStalls()
    }
}

// MARK: - UITableViewDelegate

extension StallListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.handleStallSelect(at: indexPath.row)
    }
}

// MARK: - StallListPresenterOutput

extension StallListViewController: StallListViewControllerInput {
    func displaySomething(viewModel: StallListViewModel) {
        tableViewDataSource = StallListDataSource(stalls: viewModel.stalls)
    }
}
