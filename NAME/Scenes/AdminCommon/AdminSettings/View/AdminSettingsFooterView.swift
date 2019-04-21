//
//  AdminSettingsFooterView.swift
//  NAME
//
//  Created by Caryn Heng on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsFooterViewDelegate: class {
    func saveButtonDidTap()
    func cancelButtonDidTap()
}

class AdminSettingsFooterView: UIView {
    weak var delegate: AdminSettingsFooterViewDelegate?

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleSavePress(sender:)), for: .touchUpInside)
        button.setTitle(AdminSettingsConstants.saveButtonTitle, for: .normal)
        button.layer.cornerRadius = CornerRadiusConstants.standardRadius
        button.backgroundColor = UIColor.Custom.purple
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleCancelPress(sender:)), for: .touchUpInside)
        button.setTitle(AdminSettingsConstants.cancelButtonTitle, for: .normal)
        button.layer.cornerRadius = CornerRadiusConstants.standardRadius
        button.backgroundColor = UIColor.Custom.lightGray
        return button
    }()

    init(frame: CGRect, isCancelShown: Bool) {
        super.init(frame: frame)

        addSubview(saveButton)
        addSubview(cancelButton)

        cancelButton.isHidden = !isCancelShown
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configureConstraints() {
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(ButtonConstants.mediumButtonHeight)
            make.width.equalTo(AdminSettingsConstants.saveButtonWidth)
            make.top.equalTo(safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.right.equalTo(safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }

        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(ButtonConstants.mediumButtonHeight)
            make.width.equalTo(AdminSettingsConstants.saveButtonWidth)
            make.top.equalTo(safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.right.equalTo(saveButton.snp.left).offset(-ConstraintConstants.standardValue)
        }
    }

    @objc
    func handleSavePress(sender: Any) {
        delegate?.saveButtonDidTap()
    }

    @objc
    func handleCancelPress(sender: Any) {
        delegate?.cancelButtonDidTap()
    }
}
