//
//  CustomAlertViewController.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

protocol CustomAlertViewControllerInput: CustomAlertPresenterOutput {

}

protocol CustomAlertViewControllerOutput {
}

final class CustomAlertViewController: UIViewController {
    var output: CustomAlertViewControllerOutput?
    var router: CustomAlertRouterProtocol?

    private var alertType: CustomAlertViewModel.AlertType

    private lazy var imageView: UIImageView = {
        switch alertType {
        case .error:
            let image = UIImage(named: ImageConstants.sadMascotName)
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: CustomAlertConstants.titleFontSize)
        label.textColor = UIColor.Custom.deepPurple
        label.textAlignment = .left
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.Custom.purple
        button.layer.cornerRadius = CornerRadiusConstants.standardRadius
        button.setTitle(CustomAlertConstants.doneButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(handleDonePress(sender:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Container Views

    private lazy var messageView = UIView()

    private lazy var detailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, messageView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = ConstraintConstants.standardValue
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [detailStackView, doneButton])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Custom.palePurple
        view.layer.cornerRadius = CornerRadiusConstants.standardRadius
        return view
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.5
        return view
    }()

    // MARK: - Initializers
    init(withTitle title: String,
         withMessage message: String,
         buttonText: String?,
         alertType: CustomAlertViewModel.AlertType,
         configurator: CustomAlertConfigurator = CustomAlertConfigurator.shared) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)

        titleLabel.text = title
        messageLabel.text = message
        if let buttonText = buttonText {
            doneButton.setTitle(buttonText, for: .normal)
        }

        modalPresentationStyle = .overFullScreen
        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be called without Storyboard.")
    }

    private func configure(configurator: CustomAlertConfigurator = CustomAlertConfigurator.shared) {
        configurator.configure(viewController: self)
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureConstaints()
    }

    private func addSubviews() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        messageView.addSubview(titleLabel)
        messageView.addSubview(messageLabel)
    }

    private func configureConstaints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(CustomAlertConstants.alertWidth)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ConstraintConstants.standardValue)
            make.left.equalToSuperview().offset(ConstraintConstants.standardValue)
            make.right.equalToSuperview().offset(-ConstraintConstants.standardValue)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.standardValue)
        }

        doneButton.snp.makeConstraints { make in
            make.height.equalTo(ButtonConstants.mediumButtonHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.height.equalTo(CustomAlertConstants.imageViewHeight)
            make.width.equalTo(CustomAlertConstants.imageViewHeight)
        }

        messageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(ConstraintConstants.standardValue)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.standardValue)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(ConstraintConstants.standardValue)
            make.width.equalToSuperview()
        }
    }

    @objc
    private func handleDonePress(sender: Any) {
        router?.navigateBack()
    }
}

// MARK: - CustomAlertPresenterOutput
extension CustomAlertViewController: CustomAlertViewControllerInput {
}
