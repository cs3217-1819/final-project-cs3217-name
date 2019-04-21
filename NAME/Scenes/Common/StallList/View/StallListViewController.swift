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
    func reloadEstablishmentInfo()
    func reloadStalls()
    func handleStallSelect(at index: Int)
    func handleStallDelete(at index: Int)
    func handleStallEdit(at index: Int)
    func requestSessionEnd()
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

    init(estId: String,
         isEstablishmentView: Bool,
         mediator: StallListToParentOutput?,
         configurator: StallListConfigurator = StallListConfigurator.shared) {
        self.isEstablishmentView = isEstablishmentView
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configure(estId: estId, mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        self.isEstablishmentView = false
        super.init(coder: aDecoder)
    }

    // MARK: - Configurator

    private func configure(estId: String,
                           mediator: StallListToParentOutput?,
                           configurator: StallListConfigurator = StallListConfigurator.shared) {
        configurator.configure(estId: estId, viewController: self, toParentMediator: mediator)

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
        setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        output?.reloadStalls()
        output?.reloadEstablishmentInfo()

        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
            selectedIndexPaths.isEmpty,
            collectionView.numberOfSections > 0,
            collectionView.numberOfItems(inSection: 0) > 0
            else {
                return
        }
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: animated, scrollPosition: .top)
        output?.handleStallSelect(at: 0)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        clearsSelectionOnViewWillAppear = false
    }

    private func setupNavigation() {
        if !isEstablishmentView {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                               target: self,
                                                               action: #selector(closeButtonDidPress))
        }
    }

    @objc
    private func closeButtonDidPress() {
        output?.requestSessionEnd()
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
    func didTapEdit(at cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            assertionFailure("Cannot locate index path of cell to be deleted.")
            return
        }
        output?.handleStallEdit(at: indexPath.row)
    }

    func didTapDelete(at cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            assertionFailure("Cannot locate index path of cell to be deleted.")
            return
        }

        let alert = UIAlertController(title: "Deleting stall",
                                      message: "Are you sure you want to delete this stall?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            self.output?.handleStallDelete(at: indexPath.row)
        })
        present(alert, animated: true)
    }
}

// MARK: - StallListPresenterOutput

extension StallListViewController: StallListViewControllerInput {
    func display(establishment: StallListEstablishmentViewModel) {
        title = establishment.name
    }

    func display(stallList: StallListViewModel) {
        collectionViewDataSource = StallListDataSource(isEstablishmentView: isEstablishmentView,
                                                       stalls: stallList.stalls)
    }

    func displayStallDeleteError(title: String, message: String, buttonText: String?) {
        router?.navigateToError(title: title, message: message, buttonText: buttonText)
    }

    func displayStallSettings(withId id: String) {
        router?.navigateToStallSettings(withId: id)
    }
}
