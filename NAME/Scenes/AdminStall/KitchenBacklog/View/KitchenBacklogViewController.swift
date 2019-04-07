//
//  KitchenBacklogViewController.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol KitchenBacklogViewControllerInput: KitchenBacklogPresenterOutput {
}

protocol KitchenBacklogViewControllerOutput {
    func reloadOrders()
}

final class KitchenBacklogViewController: UICollectionViewController {
    var output: KitchenBacklogViewControllerOutput?
    var router: KitchenBacklogRouterProtocol?

    let clockView = UIView()

    private var collectionViewDataSource: KitchenBacklogDataSource? {
        didSet {
            collectionView.dataSource = collectionViewDataSource
            collectionView.reloadData()
        }
    }

    // MARK: - Initializers
    init(configurator: KitchenBacklogConfigurator = KitchenBacklogConfigurator.shared) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure(configurator: KitchenBacklogConfigurator = KitchenBacklogConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupClockDisplay()
        setupCollectionView()
        getOrders()
    }

    private func setupClockDisplay() {
        // TODO: Setup clock display, just a placeholder for now
        view.addSubview(clockView)

        clockView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(KitchenBacklogConstants.clockWidth)
            make.height.equalTo(KitchenBacklogConstants.clockHeight)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        clockView.backgroundColor = .purple
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(OrderViewCell.self,
                                forCellWithReuseIdentifier: ReuseIdentifiers.orderCellIdentifier)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func getOrders() {
        output?.reloadOrders()
    }
}

// MARK: - UICollectionViewDataSource
private class KitchenBacklogDataSource: NSObject, UICollectionViewDataSource {
    private let cellViewModels: [OrderViewModel]

    init(orders: [OrderViewModel]) {
        self.cellViewModels = orders
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.orderCellIdentifier,
                                               for: indexPath) as? OrderViewCell else {
                assertionFailure("Invalid collection view cell.")
                return UICollectionViewCell()
        }

        let viewModel = cellViewModels[indexPath.row]
        cell.tableViewDelegate = OrderViewDelegate()
        cell.tableViewDataSource = OrderViewDataSource(orderItems: viewModel.orderItems)
        cell.viewModel = cellViewModels[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension KitchenBacklogViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.size.height - KitchenBacklogConstants.clockHeight
        return CGSize(width: KitchenBacklogConstants.orderWidth,
                      height: safeAreaHeight - 2 * KitchenBacklogConstants.orderMargins)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return KitchenBacklogConstants.spaceBetweenOrders
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: KitchenBacklogConstants.orderMargins,
                            bottom: 0,
                            right: KitchenBacklogConstants.orderMargins)
    }
}

// MARK: - KitchenBacklogPresenterOutput
extension KitchenBacklogViewController: KitchenBacklogViewControllerInput {
    func displayOrders(viewModel: KitchenBacklogViewModel) {
        collectionViewDataSource = KitchenBacklogDataSource(orders: viewModel.orders)
    }
}

extension KitchenBacklogViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
