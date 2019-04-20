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
    func handleOrderCompleted(at index: Int)
    func handleOrderReady(at index: Int)
}

final class KitchenBacklogViewController: UICollectionViewController {
    var output: KitchenBacklogViewControllerOutput?
    var router: KitchenBacklogRouterProtocol?

    private let clockView = KitchenClockView()

    private var timer: Timer?

    private var collectionViewDataSource: KitchenBacklogDataSource? {
        didSet {
            collectionViewDataSource?.delegate = self
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

        view.backgroundColor = .white
        collectionView.backgroundColor = .white

        setupCollectionView()
        view.addSubview(clockView)
        configureConstraints()

        getOrders()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupTimer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        invalidateTimer()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.bounces = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(KitchenBacklogCell.self,
                                forCellWithReuseIdentifier: ReuseIdentifiers.orderCellIdentifier)
    }

    private func configureConstraints() {
        clockView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(KitchenBacklogConstants.clockWidth)
            make.height.equalTo(KitchenBacklogConstants.clockHeight)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func getOrders() {
        output?.reloadOrders()
    }

    // MARK: - Timer Helpers

    private func setupTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.clockView.updateTime()

            let visibleCells = self.collectionView.indexPathsForVisibleItems
                .compactMap { self.collectionView.cellForItem(at: $0) as? KitchenBacklogCell }
            self.collectionViewDataSource?.updateCellTimers(for: visibleCells)
        }

        guard let timer = timer else {
            assertionFailure("Timer was not set")
            return
        }
        // Add timer to common run loop so that it will still fire when scrolling in collection view.
        RunLoop.current.add(timer, forMode: .common)
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Child View Controller Helpers

    private func getNewOrderViewController(orderId: String) -> UIViewController {
        guard let router = router else {
            return UIViewController()
        }
        let viewController = router.orderViewController(orderId: orderId)
        addChildContentViewController(viewController)
        return viewController
    }

    private func removeAllChildViewControllers() {
        children.forEach { removeChildContentViewController($0) }
    }

    private func addChildContentViewController(_ childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }

    private func removeChildContentViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}

// MARK: - OrderViewCellDelegate
extension KitchenBacklogViewController: KitchenBacklogCellDelegate {
    func didTapCompleted(forCell cell: UICollectionViewCell) {
        let indexPath = getIndexPath(for: cell)
        output?.handleOrderCompleted(at: indexPath.row)
    }

    func didTapAllReady(forCell cell: UICollectionViewCell) {
        let indexPath = getIndexPath(for: cell)
        output?.handleOrderReady(at: indexPath.row)
    }

    private func getIndexPath(for cell: UICollectionViewCell) -> IndexPath {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            assertionFailure("Cannot locate index path of order cell.")
            return IndexPath()
        }
        return indexPath
    }
}

// MARK: - UICollectionViewDataSource
private class KitchenBacklogDataSource: NSObject, UICollectionViewDataSource {
    private struct Section {
        let cellViews: [UIView?]
        let cellViewModel: [KitchenBacklogViewModel.OrderViewModel]
    }
    private let sections: [Section]

    weak var delegate: KitchenBacklogCellDelegate?

    init(preparedViews: [UIView?],
         preparedViewModels: [KitchenBacklogViewModel.OrderViewModel],
         unpreparedViews: [UIView?],
         unpreparedViewModels: [KitchenBacklogViewModel.OrderViewModel]) {
        sections = [Section(cellViews: preparedViews, cellViewModel: preparedViewModels),
                    Section(cellViews: unpreparedViews, cellViewModel: unpreparedViewModels)]
        super.init()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cellViews.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.orderCellIdentifier,
                                                      for: indexPath)
        guard let orderCell = cell as? KitchenBacklogCell else {
                assertionFailure("Invalid collection view cell.")
                return cell
        }
        let viewModel = sections[indexPath.section].cellViewModel[indexPath.row]
        orderCell.set(headerTitle: viewModel.title,
                      isOrderReady: indexPath.section == 0,
                      timeReceived: viewModel.timeStamp,
                      orderView: sections[indexPath.section].cellViews[indexPath.row])
        orderCell.updateTimer()
        orderCell.delegate = delegate
        return cell
    }

    func updateCellTimers(for cells: [KitchenBacklogCell]) {
        cells.forEach { $0.updateTimer() }
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
        return UIEdgeInsets(top: 0, left: KitchenBacklogConstants.orderMargins, bottom: 0, right: 0)
    }
}

// MARK: - KitchenBacklogPresenterOutput
extension KitchenBacklogViewController: KitchenBacklogViewControllerInput {
    func displayOrders(viewModel: KitchenBacklogViewModel) {
        // Remove all old child view controllers
        removeAllChildViewControllers()
        let preparedViews = viewModel.preparedOrders
            .map { getNewOrderViewController(orderId: $0.orderId).view }
        let unpreparedViews = viewModel.unpreparedOrders
            .map { getNewOrderViewController(orderId: $0.orderId).view }

        collectionViewDataSource = KitchenBacklogDataSource(preparedViews: preparedViews,
                                                            preparedViewModels: viewModel.preparedOrders,
                                                            unpreparedViews: unpreparedViews,
                                                            unpreparedViewModels: viewModel.unpreparedOrders)
    }

}

extension KitchenBacklogViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
