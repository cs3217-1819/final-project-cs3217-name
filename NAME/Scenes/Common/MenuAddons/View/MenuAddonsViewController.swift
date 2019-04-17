//
//  MenuAddonsViewController.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuAddonsViewControllerInput: MenuAddonsPresenterOutput {

}

protocol MenuAddonsViewControllerOutput {
    func loadOptions()
    func reset()
    func reset(section: Int)
    func updateValue(at index: Int, with valueIndexOrQuantity: Int)
    func updateQuantity(_ quantity: Int)
    func finalizeOrderItem(diningOption: OrderItem.DiningOption)
}

protocol MenuAddonsTableViewCellProvider: class {
    func dequeueReusableCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    var delegate: MenuAddonsTableViewCellDelegate? { get set }
}

protocol MenuAddonsTableViewCellDelegate: class {
    func valueDidSelect(section: Int, itemOrQuantity: Int)
}

final class MenuAddonsViewController: UIViewController {
    private let headerIdentifier = "headerIdentifier"

    var output: MenuAddonsViewControllerOutput?
    var router: MenuAddonsRouterProtocol?

    private var cellDelegates: [MenuAddonsTableViewCellProvider?] = []
    private var sectionNames: [String] = []

    private lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero, style: .grouped)
        result.delegate = self
        result.dataSource = self
        result.backgroundColor = .white
        result.separatorStyle = .none
        result.allowsSelection = false
        result.rowHeight = MenuAddonsConstants.addonsSize.height
        result.estimatedRowHeight = result.rowHeight
        result.sectionFooterHeight = 0.0
        result.sectionHeaderHeight = MenuAddonsConstants.sectionHeaderHeight
        result.register(MenuAddonsTableViewChoiceCell.self,
                        forCellReuseIdentifier: MenuAddonsTableViewChoiceCell.reuseIdentifier)
        result.register(MenuAddonsTableViewQuantityCell.self,
                        forCellReuseIdentifier: MenuAddonsTableViewQuantityCell.reuseIdentifier)
        result.register(MenuAddonsTableViewHeaderView.self,
                        forHeaderFooterViewReuseIdentifier: headerIdentifier)
        return result
    }()

    private let dividerLine: UIView = {
        let result = UIView(frame: .zero)
        result.backgroundColor = .lightGray
        return result
    }()

    private lazy var footerView: MenuAddonsFooterView = {
        let result = MenuAddonsFooterView()
        result.delegate = self
        return result
    }()

    // MARK: - Initializers
    init(menuId: String, mediator: MenuAddonsToParentOutput?, configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(menuId: menuId, mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("This should not be called without Storyboard.")
    }

    private func configure(menuId: String, mediator: MenuAddonsToParentOutput?, configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
        configurator.configure(viewController: self, menuId: menuId, toParentMediator: mediator)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        configureConstraints()
        output?.loadOptions()
    }

    private func setupView() {
        view.backgroundColor = .white
        let resetBarButtonItem = UIBarButtonItem(title: MenuAddonsConstants.resetButtonTitle,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(resetButtonDidPress))
        resetBarButtonItem.tintColor = .red
        navigationItem.rightBarButtonItem = resetBarButtonItem
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(dividerLine)
        view.addSubview(footerView)
    }

    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        dividerLine.snp.makeConstraints { make in
            make.height.equalTo(ConstraintConstants.dividerWidth)
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        footerView.snp.makeConstraints { make in
            make.height.equalTo(MenuAddonsConstants.footerViewHeight)
            make.top.equalTo(dividerLine.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc
    private func resetButtonDidPress() {
        output?.reset()
    }
}

// MARK: - UITableViewDataSource
extension MenuAddonsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellDelegate = cellDelegates[indexPath.section] else {
            return UITableViewCell()
        }
        return cellDelegate.dequeueReusableCell(tableView: tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return cellDelegates.count
    }
}

// MARK: - UITableViewDelegate
extension MenuAddonsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let reusableView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
        guard let headerView = reusableView as? MenuAddonsTableViewHeaderView,
            let title = self.tableView(tableView, titleForHeaderInSection: section) else {
            return nil
        }
        headerView.set(section: section, title: title)
        headerView.delegate = self
        return headerView
    }
}

// MARK: - MenuAddonsTableViewHeaderViewDelegate
extension MenuAddonsViewController: MenuAddonsTableViewHeaderViewDelegate {
    func resetButtonDidTap(section: Int) {
        output?.reset(section: section)
    }
}

// MARK: - MenuAddonsFooterViewDelegate
extension MenuAddonsViewController: MenuAddonsFooterViewDelegate {
    func quantityDidChange(newValue: Int) {
        output?.updateQuantity(newValue)
    }

    func addButtonDidPress(sender: UIButton) {
        let actionSheet = UIAlertController(title: MenuAddonsConstants.diningOptionTitle,
                                            message: nil, preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        for case let (title: title, value: value) in MenuAddonsConstants.diningOptionLabels {
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.output?.finalizeOrderItem(diningOption: value)
                self?.router?.navigateBack()
            }
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
}

// MARK: - MenuAddonsTableViewCellDelegate
extension MenuAddonsViewController: MenuAddonsTableViewCellDelegate {
    func valueDidSelect(section: Int, itemOrQuantity: Int) {
        output?.updateValue(at: section, with: itemOrQuantity)
    }
}

// MARK: - MenuAddonsPresenterOutput
extension MenuAddonsViewController: MenuAddonsViewControllerInput {
    func display(viewModel: MenuAddonsViewModel) {
        footerView.price = viewModel.totalPrice
        sectionNames = viewModel.options.map { $0.name }
        cellDelegates = viewModel.options.enumerated().map { arg -> MenuAddonsTableViewCellProvider? in
            let (section, option) = arg
            switch (option.type, option.value) {
            case let (.quantity(price: price), .quantity(quantity)):
                let provider = MenuAddonsQuantityViewDelegate(price: price, quantity: quantity, section: section)
                provider.delegate = self
                return provider
            case let (.choices(choices), .choices(choiceIndices)):
                let provider = MenuAddonsCollectionViewDataSourceDelegate(choices: choices,
                                                                          selectedIndices: choiceIndices,
                                                                          section: section)
                provider.delegate = self
                return provider
            default:
                return nil
            }
        }
        tableView.reloadData()
    }
}
