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

    init(configurator: StallListConfigurator = StallListConfigurator.shared) {
        super.init(style: .plain)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: StallListConfigurator = StallListConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)

        tableView.register(StallListTableViewCell.self,
                           forCellReuseIdentifier: StallListViewController.stallCellIdentifier)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.reloadStalls()
    }
}

// MARK: - StallListPresenterOutput

extension StallListViewController: StallListViewControllerInput {
    func displaySomething(viewModel: StallListViewModel) {
        tableViewDataSource = StallListDataSource(stalls: viewModel.stalls)
    }
}

// MARK: - UIViewControllerRestoration

extension StallListViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
