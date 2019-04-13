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
    func changeComment(_ comment: String)
}

final class MenuInfoViewController: UIViewController {
    var output: MenuInfoViewControllerOutput?
    var router: MenuInfoRouterProtocol?

    // TODO use real image
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

    private let detailsTextView: UITextView = {
        let result = UITextView(frame: .zero)
        result.isEditable = false
        result.isSelectable = false
        result.font = .preferredFont(forTextStyle: .body)
        result.textContainer.maximumNumberOfLines = MenuAddonsConstants.maximumNumberOfLines
        return result
    }()

    private let commentLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.text = MenuAddonsConstants.commentLabelText
        return result
    }()

    private lazy var deleteCommentButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle(MenuAddonsConstants.deleteCommentButtonTitle, for: .normal)
        result.setTitleColor(.red, for: .normal)
        result.isHidden = true
        result.addTarget(self, action: #selector(deleteCommentButtonDidPress), for: .touchUpInside)
        return result
    }()

    private lazy var commentTextView: UITextView = {
        let result = UITextView(frame: .zero)
        result.isEditable = false
        result.isScrollEnabled = false
        result.font = .preferredFont(forTextStyle: .body)
        result.textContainer.maximumNumberOfLines = MenuAddonsConstants.maximumNumberOfLines
        result.layer.borderColor = UIColor.black.cgColor
        result.layer.borderWidth = 1.0
        result.layer.cornerRadius = 10
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(textViewDidTap))
        result.addGestureRecognizer(tapRecognizer)
        return result
    }()

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
        view.addSubview(detailsTextView)
        view.addSubview(commentLabel)
        view.addSubview(deleteCommentButton)
        view.addSubview(commentTextView)
    }

    func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.height.equalTo(view.safeAreaLayoutGuide).dividedBy(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.height.equalTo(priceLabel)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        detailsTextView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(detailsTextView.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
        }
        deleteCommentButton.snp.makeConstraints { make in
            make.top.equalTo(commentLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
            make.height.equalTo(commentLabel)
        }
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(ConstraintConstants.standardValue)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
            make.height.equalTo(detailsTextView)
        }
    }

    @objc
    private func closeButtonDidPress() {
        router?.navigateBack()
    }

    @objc
    private func textViewDidTap() {
        let alertController = UIAlertController(title: MenuAddonsConstants.extraCommentAlertTitle,
                                                message: nil, preferredStyle: .alert)
        alertController.addTextField { $0.text = self.commentTextView.text }
        let okAction = UIAlertAction(title: AlertConstants.okTitle,
                                     style: .default) { [weak alertController, weak self] _ in
            guard let self = self,
                let text = alertController?.textFields?.first?.text else {
                return
            }
            self.output?.changeComment(text)
        }
        let cancelAction = UIAlertAction(title: AlertConstants.cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc
    private func deleteCommentButtonDidPress() {
        output?.changeComment("")
    }
}

// MARK: - MenuInfoPresenterOutput
extension MenuInfoViewController: MenuInfoViewControllerInput {
    func display(comment: String) {
        commentTextView.text = comment
        deleteCommentButton.isHidden = (commentTextView.text == "")
    }

    func display(viewModel: MenuInfoViewModel) {
        nameLabel.text = viewModel.name
        detailsTextView.text = viewModel.details
        priceLabel.text = viewModel.price
    }
}
