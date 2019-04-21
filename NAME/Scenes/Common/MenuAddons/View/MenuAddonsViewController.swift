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
    func addChoice(section: Int, name: String, price: String)
    func addOption(type: MenuItemOptionType.MetaType, name: String, price: String?)
    func finalizeOrderItem(diningOption: OrderItem.DiningOption)
    func reorderUp(section: Int)
    func reorderDown(section: Int)
}

protocol MenuAddonsTableViewCellProvider: class {
    func dequeueReusableCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    var delegate: MenuAddonsTableViewCellDelegate? { get set }
}

protocol MenuAddonsTableViewCellDelegate: class {
    func valueDidSelect(section: Int, itemOrQuantity: Int)
    func addCellDidTap(section: Int)
    func addOptionDidTap(sender: UIButton)
}

final class MenuAddonsViewController: UIViewController {
    private let headerIdentifier = "headerIdentifier"

    var output: MenuAddonsViewControllerOutput?
    var router: MenuAddonsRouterProtocol?

    private var cellDelegates: [MenuAddonsTableViewCellProvider?] = []
    private var sectionNames: [(name: String, section: Int)] = []

    private lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero, style: .grouped)
        result.delegate = self
        result.dataSource = self
        result.backgroundColor = UIColor.Custom.paleGray
        result.separatorStyle = .none
        result.allowsSelection = false
        result.rowHeight = MenuAddonsConstants.addonsSize.height
        result.estimatedRowHeight = result.rowHeight
        result.sectionFooterHeight = 0.0
        result.sectionHeaderHeight = MenuAddonsConstants.sectionHeaderHeight
        result.register(MenuAddonsTableViewAddCell.self,
                        forCellReuseIdentifier: MenuAddonsTableViewAddCell.reuseIdentifier)
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

    private let isEditable: Bool

    // MARK: - Initializers
    init(menuId: String,
         isEditable: Bool,
         mediator: MenuAddonsToParentOutput?,
         configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
        self.isEditable = isEditable
        super.init(nibName: nil, bundle: nil)
        configure(menuId: menuId, mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be called without Storyboard.")
    }

    private func configure(menuId: String,
                           mediator: MenuAddonsToParentOutput?,
                           configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
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
        view.backgroundColor = MenuAddonsConstants.backgroundColor
        if !isEditable {
            let resetBarButtonItem = UIBarButtonItem(title: MenuAddonsConstants.resetButtonTitle,
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(resetButtonDidPress))
            resetBarButtonItem.tintColor = UIColor.Custom.salmonRed
            navigationItem.rightBarButtonItem = resetBarButtonItem
        }
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
        return sectionNames[section].name
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
        // Hide reset button when editable
        let isResettable = !isEditable
        // Hide reorder buttons on new option and addons, if editable
        let isReorderable = isEditable && section != 0 && section != sectionNames.count - 1
        headerView.set(section: sectionNames[section].section,
                       title: title,
                       isResettable: isResettable,
                       isReorderable: isReorderable)
        headerView.delegate = self
        return headerView
    }
}

// MARK: - MenuAddonsTableViewHeaderViewDelegate
extension MenuAddonsViewController: MenuAddonsTableViewHeaderViewDelegate {
    func resetButtonDidTap(section: Int) {
        output?.reset(section: section)
    }

    func reorderUpButtonDidTap(section: Int) {
        output?.reorderUp(section: section)
    }

    func reorderDownButtonDidTap(section: Int) {
        output?.reorderDown(section: section)
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
    func addOptionDidTap(sender: UIButton) {
        let actionSheet = UIAlertController(title: MenuAddonsConstants.addOptionTypeTitle,
                                            message: nil, preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceView = sender
        actionSheet.popoverPresentationController?.sourceRect = sender.bounds
        for case let (name, value) in MenuAddonsConstants.addOptionTypeChoices {
            let action = UIAlertAction(title: name, style: .default) { [unowned self] _ in
                self.newOptionAskName(type: value)
            }
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }

    private func newOptionAskName(type: MenuItemOptionType.MetaType) {
        let alert = AlertHelper
            .makeAlertController(title: MenuAddonsConstants.addOptionNameTitle,
                                 message: nil,
                                 textFieldText: "") { [unowned self] text in
                guard let text = text else {
                    return
                }
                if type.isPriceNeeded {
                    self.newOptionAskPrice(type: type, name: text)
                } else {
                    self.output?.addOption(type: type, name: text, price: nil)
                }
            }
        present(alert, animated: true, completion: nil)
    }

    private func newOptionAskPrice(type: MenuItemOptionType.MetaType, name: String) {
        let alert = AlertHelper
            .makeAlertController(title: MenuAddonsConstants.addOptionPriceTitle,
                                 message: nil,
                                 textFieldText: MenuAddonsConstants.priceDefaultValue) { [unowned self] text in
                guard let text = text else {
                    return
                }
                self.output?.addOption(type: type, name: name, price: text)
            }
        present(alert, animated: false, completion: nil)
    }

    func addCellDidTap(section: Int) {
        guard let lastSection = sectionNames.last?.section,
            let sectionName = sectionNames.first(where: { $0.section == section })?.name else {
            return
        }
        guard section != lastSection else {
            let alert = AlertHelper
                .makeAlertController(title: MenuAddonsConstants.featureComingSoon,
                                     message: nil,
                                     textFieldText: nil,
                                     showCancelButton: false) { _ in }
            present(alert, animated: true, completion: nil)
            return
        }
        let title = String(format: MenuAddonsConstants.addChoiceNameTitle, sectionName)
        newChoiceAskName(section: section, title: title)
    }

    private func newChoiceAskName(section: Int, title: String) {
        let alert = AlertHelper.makeAlertController(title: title,
                                                    message: MenuAddonsConstants.addChoiceNameMessage,
                                                    textFieldText: "") { [unowned self] text in
            guard let text = text else {
                return
            }
            self.newChoiceAskPrice(section: section, title: title, name: text)
        }
        present(alert, animated: true, completion: nil)
    }

    private func newChoiceAskPrice(section: Int, title: String, name: String) {
        let alert = AlertHelper
            .makeAlertController(title: title,
                                 message: MenuAddonsConstants.addChoicePriceMessage,
                                 textFieldText: MenuAddonsConstants.priceDefaultValue) { [unowned self] text in
                guard let text = text else {
                    return
                }
                self.output?.addChoice(section: section, name: name, price: text)
            }
        present(alert, animated: true, completion: nil)
    }

    func valueDidSelect(section: Int, itemOrQuantity: Int) {
        output?.updateValue(at: section, with: itemOrQuantity)
    }
}

// MARK: - MenuAddonsPresenterOutput
extension MenuAddonsViewController: MenuAddonsViewControllerInput {
    func display(viewModel: MenuAddonsViewModel) {
        footerView.price = viewModel.totalPrice
        sectionNames = (isEditable ? [(MenuAddonsConstants.addOptionSectionName, 0)] : []) +
            viewModel.options.enumerated().map { ($0.element.name, $0.offset) }
        cellDelegates = (isEditable ? [MenuAddonsAddOptionDelegate(delegate: self)] : []) +
            viewModel.options.enumerated().map { arg -> MenuAddonsTableViewCellProvider? in
                let (section, option) = arg
                switch (option.type, option.value) {
                case let (.quantity(price: price), .quantity(quantity)):
                    let provider = MenuAddonsQuantityViewDelegate(price: price,
                                                                  quantity: quantity,
                                                                  section: section,
                                                                  isEditable: isEditable)
                    provider.delegate = self
                    return provider
                case let (.choices(choices, isEditable), .choices(choiceIndices)):
                    let provider = MenuAddonsCollectionViewDataSourceDelegate(choices: choices,
                                                                              selectedIndices: choiceIndices,
                                                                              section: section,
                                                                              isEditable: isEditable && self.isEditable)
                    provider.delegate = self
                    return provider
                default:
                    return nil
                }
            }
        tableView.reloadData()
    }
}
