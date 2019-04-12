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
    func updateValue(at index: Int, with valueIndexOrQuantity: Int)
}

private final class MenuAddonsDataSource: NSObject, UITableViewDataSource {
    private let cellIdentifier: String

    private let options: [MenuAddonsViewModel.MenuOptionViewModel]

    private unowned let cellDelegate: MenuAddonsTableViewCellDelegate

    init(options: [MenuAddonsViewModel.MenuOptionViewModel], cellIdentifier: String,
         cellDelegate: MenuAddonsTableViewCellDelegate) {
        self.options = options
        self.cellIdentifier = cellIdentifier
        self.cellDelegate = cellDelegate
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let cell = reusableCell as? MenuAddonsTableViewCell else {
            return reusableCell
        }
        let option = options[indexPath.section]
        cell.section = indexPath.section
        cell.type = option.type
        cell.value = option.value
        cell.delegate = cellDelegate
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return options[section].name
    }
}

final class MenuAddonsViewController: UIViewController {
    private static let cellIdentifier = "cellIdentifier"

    var output: MenuAddonsViewControllerOutput?
    var router: MenuAddonsRouterProtocol?

    private lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero, style: .grouped)
        result.delegate = self
        result.backgroundColor = .white
        result.separatorStyle = .none
        result.allowsSelection = false
        result.rowHeight = MenuAddonsConstants.addonsSize.height
        result.estimatedRowHeight = result.rowHeight
        result.register(MenuAddonsTableViewCell.self,
                        forCellReuseIdentifier: MenuAddonsViewController.cellIdentifier)
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

    private var tableViewDataSource: MenuAddonsDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
            tableView.reloadData()
        }
    }

    // MARK: - Initializers
    init(menuId: String, configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(menuId: menuId, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("This should not be called without Storyboard.")
    }

    private func configure(menuId: String, configurator: MenuAddonsConfigurator = MenuAddonsConfigurator.shared) {
        configurator.configure(viewController: self, menuId: menuId)
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

// MARK: - UITableViewDelegate
extension MenuAddonsViewController: UITableViewDelegate {

}

// MARK: - MenuAddonsFooterViewDelegate
extension MenuAddonsViewController: MenuAddonsFooterViewDelegate {
    func addButtonDidPress() {
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
        tableViewDataSource = MenuAddonsDataSource(options: viewModel.options,
                                                   cellIdentifier: MenuAddonsViewController.cellIdentifier,
                                                   cellDelegate: self)
    }
}
