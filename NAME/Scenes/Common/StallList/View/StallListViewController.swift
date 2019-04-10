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
    func handleStallDelete(at index: Int)
}

final class StallListViewController: UICollectionViewController {
    private static let stallCustomerCellIdentifier = "stallCustomerCellIdentifier"
    private static let stallEstablishmentCellIdentifier = "stallEstablishmentCellIdentifier"

    private let isEstablishmentView: Bool

    private class StallListDataSource: NSObject, UICollectionViewDataSource {
        private let cellViewModels: [StallListViewModel.StallViewModel]
        private var isEstablishmentView: Bool

        weak var delegate: StallListTableViewCellDelegate?

        init(isEstablishmentView: Bool, stalls: [StallListViewModel.StallViewModel]) {
            self.isEstablishmentView = isEstablishmentView
            self.cellViewModels = stalls
            super.init()
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cellViewModels.count
        }

        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let model = cellViewModels[indexPath.row]

            if isEstablishmentView {
                let cell = dequeueEstablishmentReusableCell(collectionView, at: indexPath)
                cell.viewModel = model
                cell.delegate = delegate
                cell.backgroundColor = .white
                return cell
            } else {
                let cell = dequeueCustomerReusableCell(collectionView, at: indexPath)
                cell.viewModel = model
                return cell
            }
        }

        private func dequeueCustomerReusableCell(_ collectionView: UICollectionView,
                                                 at indexPath: IndexPath) -> StallListCustomerCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stallCustomerCellIdentifier,
                                                                for: indexPath) as? StallListCustomerCell else {
                assertionFailure("Stall list cell not set up properly or not registered.")
                return StallListCustomerCell()
            }
            return cell
        }

        private func dequeueEstablishmentReusableCell(_ collectionView: UICollectionView,
                                                      at indexPath: IndexPath) -> StallListEstablishmentCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stallEstablishmentCellIdentifier,
                                                                for: indexPath) as? StallListEstablishmentCell else {
                assertionFailure("Stall list cell not set up properly or not registered.")
                return StallListEstablishmentCell()
            }
            return cell
        }
    }

    private var collectionViewDataSource: StallListDataSource? {
        didSet {
            collectionViewDataSource?.delegate = self
            collectionView.dataSource = collectionViewDataSource
            collectionView.reloadData()
        }
    }

    var output: StallListViewControllerOutput?
    var router: StallListRouterProtocol?

    // MARK: - Initializers

    init(isEstablishmentView: Bool,
         mediator: StallListToParentOutput?,
         configurator: StallListConfigurator = StallListConfigurator.shared) {
        self.isEstablishmentView = isEstablishmentView
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configure(mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        self.isEstablishmentView = false
        super.init(coder: aDecoder)
    }

    // MARK: - Configurator

    private func configure(mediator: StallListToParentOutput?,
                           configurator: StallListConfigurator = StallListConfigurator.shared) {
        configurator.configure(viewController: self, toParentMediator: mediator)

        if isEstablishmentView {
            collectionView
                .register(StallListEstablishmentCell.self,
                          forCellWithReuseIdentifier: StallListViewController.stallEstablishmentCellIdentifier)
        } else {
            collectionView.register(StallListCustomerCell.self,
                                    forCellWithReuseIdentifier: StallListViewController.stallCustomerCellIdentifier)
        }
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        output?.reloadStalls()
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        clearsSelectionOnViewWillAppear = false
    }
}

// MARK: - UICollectionViewDelegate

extension StallListViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.handleStallSelect(at: indexPath.row)
    }
}

extension StallListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isEstablishmentView {
            return CGSize(width: StallListConstants.establishmentCellWidth,
                          height: StallListConstants.establishmentCellHeight)
        } else {
            return CGSize(width: view.frame.width,
                          height: StallListConstants.customerCellHeight)
        }
    }

}

// MARK: - StallListTableViewCellDelegate
extension StallListViewController: StallListTableViewCellDelegate {
    func didTapEdit() {
        router?.navigateToStallSettings()
    }

    func didTapDelete(at cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            assertionFailure("Cannot locate index path of cell to be deleted.")
            return
        }
        output?.handleStallDelete(at: indexPath.row)
    }
}

// MARK: - StallListPresenterOutput

extension StallListViewController: StallListViewControllerInput {
    func displaySomething(viewModel: StallListViewModel) {
        collectionViewDataSource = StallListDataSource(isEstablishmentView: isEstablishmentView,
                                                       stalls: viewModel.stalls)
    }

    func displayStallDeleteError() {
        // TODO: Display Error
    }
}
