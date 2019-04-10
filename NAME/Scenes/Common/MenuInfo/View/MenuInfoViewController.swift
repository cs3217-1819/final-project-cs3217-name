//
//  MenuInfoViewController.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol MenuInfoViewControllerInput: MenuInfoPresenterOutput {

}

protocol MenuInfoViewControllerOutput {
    func loadMenuDisplayable()
}

final class MenuInfoViewController: UIViewController {
    var output: MenuInfoViewControllerOutput?
    var router: MenuInfoRouterProtocol?

    private let imageView: UIImageView = {
        let result = UIImageView(frame: .zero)
        result.backgroundColor = .gray
        return result
    }()
    private let nameLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.font = .preferredFont(forTextStyle: .title1)
        return result
    }()
    private let priceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.textAlignment = .right
        result.font = .preferredFont(forTextStyle: .title1)
        return result
    }()
    private let detailsLabel = UILabel(frame: .zero)

    // MARK: - Initializers
    init(menuId: String, configurator: MenuInfoConfigurator = MenuInfoConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(menuId: menuId, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assertionFailure("This should not be called without Storyboard.")
    }

    private func configure(menuId: String, configurator: MenuInfoConfigurator = MenuInfoConfigurator.shared) {
        configurator.configure(viewController: self, menuId: menuId)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        configureConstraints()

        output?.loadMenuDisplayable()
    }

    func setupView() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(closeButtonDidPress))
    }

    func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(detailsLabel)
    }

    func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(ConstraintConstants.standardValue)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).dividedBy(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-ConstraintConstants.standardValue)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(ConstraintConstants.standardValue)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-ConstraintConstants.standardValue)
        }
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-ConstraintConstants.standardValue)
        }
    }

    @objc
    private func closeButtonDidPress() {
        router?.navigateBack()
    }
}

// MARK: - MenuInfoPresenterOutput
extension MenuInfoViewController: MenuInfoViewControllerInput {
    func display(viewModel: MenuInfoViewModel) {
        nameLabel.text = viewModel.name
        detailsLabel.text = viewModel.details
        priceLabel.text = viewModel.price
    }
}
