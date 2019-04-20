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
    func changeDetails(_ details: String)
    func changeName(_ name: String)
    func changePrice(_ price: String)
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

    private lazy var nameLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.font = .preferredFont(forTextStyle: .title1)
        if isEditable {
            stylizeViewAsEditable(result)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(nameLabelDidTap))
            result.addGestureRecognizer(tapRecognizer)
            result.isUserInteractionEnabled = true
        }
        return result
    }()

    private lazy var priceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.textAlignment = .right
        result.font = .preferredFont(forTextStyle: .title1)
        if isEditable {
            stylizeViewAsEditable(result)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(priceLabelDidTap))
            result.addGestureRecognizer(tapRecognizer)
            result.isUserInteractionEnabled = true
        }
        return result
    }()

    private lazy var detailsTextView: UITextView = {
        let result = UITextView(frame: .zero)
        result.isSelectable = isEditable
        if isEditable {
            stylizeViewAsEditable(result)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsTextViewDidTap))
            result.addGestureRecognizer(tapRecognizer)
        }
        result.font = .preferredFont(forTextStyle: .body)
        result.textColor = .darkGray
        result.textContainer.maximumNumberOfLines = MenuInfoConstants.maximumNumberOfLines
        return result
    }()

    private lazy var commentLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.text = MenuInfoConstants.commentLabelText
        result.isHidden = isEditable
        return result
    }()

    private lazy var deleteCommentButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle(MenuInfoConstants.deleteCommentButtonTitle, for: .normal)
        result.setTitleColor(UIColor.Custom.salmonRed, for: .normal)
        result.isHidden = true
        result.addTarget(self, action: #selector(deleteCommentButtonDidPress), for: .touchUpInside)
        return result
    }()

    private lazy var commentTextView: UITextView = {
        let result = UITextView(frame: .zero)
        result.isEditable = false
        result.isScrollEnabled = false
        result.font = .preferredFont(forTextStyle: .body)
        result.textColor = .darkGray
        result.textContainer.maximumNumberOfLines = MenuInfoConstants.maximumNumberOfLines
        stylizeViewAsEditable(result)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentTextViewDidTap))
        result.addGestureRecognizer(tapRecognizer)
        result.isHidden = isEditable
        return result
    }()

    private let isEditable: Bool

    // MARK: - Initializers
    init(menuId: String,
         isEditable: Bool,
         mediator: MenuInfoToParentOutput?,
         configurator: MenuInfoConfigurator = MenuInfoConfigurator.shared) {
        self.isEditable = isEditable
        super.init(nibName: nil, bundle: nil)
        configure(menuId: menuId, mediator: mediator, configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be called without Storyboard.")
    }

    private func configure(menuId: String,
                           mediator: MenuInfoToParentOutput?,
                           configurator: MenuInfoConfigurator = MenuInfoConfigurator.shared) {
        configurator.configure(viewController: self, menuId: menuId, toParentMediator: mediator)
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
        imageView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.height.equalTo(view.safeAreaLayoutGuide).dividedBy(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.height.equalTo(priceLabel)
        }
        priceLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel)
            make.leading.equalTo(nameLabel.snp.trailing).offset(ConstraintConstants.standardValue)
            make.width.equalTo(priceLabel.intrinsicContentSize.width)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        detailsTextView.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        commentLabel.snp.remakeConstraints { make in
            make.top.equalTo(detailsTextView.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
        }
        deleteCommentButton.snp.remakeConstraints { make in
            make.top.equalTo(commentLabel)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
            make.height.equalTo(commentLabel)
        }
        commentTextView.snp.remakeConstraints { make in
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
    private func commentTextViewDidTap() {
        let alertController =
            AlertHelper.makeAlertController(title: MenuInfoConstants.extraCommentAlertTitle,
                                            message: nil,
                                            textFieldText: commentTextView.text) { [unowned self] text in
                guard let text = text else {
                    return
                }
                self.output?.changeComment(text)
            }
        present(alertController, animated: true, completion: nil)
    }

    @objc
    private func detailsTextViewDidTap() {
        let alertController =
            AlertHelper.makeAlertController(title: MenuInfoConstants.detailsAlertTitle,
                                            message: nil,
                                            textFieldText: detailsTextView.text) { [unowned self] text in
                guard let text = text else {
                    return
                }
                self.output?.changeDetails(text)
            }
        present(alertController, animated: true, completion: nil)
    }

    @objc
    private func deleteCommentButtonDidPress() {
        output?.changeComment("")
    }

    @objc
    private func priceLabelDidTap() {
        guard let price = priceLabel.text?.priceAsDouble() else {
            return
        }
        let alertController =
            AlertHelper.makeAlertController(title: MenuInfoConstants.priceAlertTitle,
                                            message: nil,
                                            textFieldText: "\(price)") { [weak self] text in
                guard let self = self, let text = text else {
                    return
                }
                self.output?.changePrice(text)
            }
        present(alertController, animated: true, completion: nil)
    }

    @objc
    private func nameLabelDidTap() {
        let alertController =
            AlertHelper.makeAlertController(title: MenuInfoConstants.nameAlertTitle,
                                            message: nil,
                                            textFieldText: nameLabel.text) { [weak self] text in
                guard let self = self, let text = text else {
                    return
                }
                self.output?.changeName(text)
            }
        present(alertController, animated: true, completion: nil)
    }

    private func stylizeViewAsEditable(_ view: UIView) {
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 10
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
        configureConstraints()
    }
}
