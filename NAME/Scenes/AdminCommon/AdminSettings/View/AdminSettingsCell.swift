//
//  AdminSettingsCell.swift
//  NAME
//
//  Created by Caryn Heng on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

protocol AdminSettingsCellDelegate: class {
    func newInput(_ input: String?, for fieldType: AdminSettingsViewModel.FieldType)
}

class AdminSettingsCell: UITableViewCell {

    weak var delegate: AdminSettingsCellDelegate?

    private var type: AdminSettingsViewModel.FieldType?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .right
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleLabel)
        addSubview(textField)
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not be called without Storyboard.")
    }

    func set(title: String, fieldPlaceholer: String, type: AdminSettingsViewModel.FieldType) {
        self.type = type
        titleLabel.text = title
        textField.text = fieldPlaceholer
    }

    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.width.equalTo(safeAreaLayoutGuide)
                .multipliedBy(AdminSettingsConstants.cellSplitFraction)
                .offset(-2 * ConstraintConstants.standardValue)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }

        textField.snp.makeConstraints { make in
            make.right.equalTo(safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
            make.width.equalTo(safeAreaLayoutGuide)
                .multipliedBy(1 - AdminSettingsConstants.cellSplitFraction)
                .offset(-2 * ConstraintConstants.standardValue)
            make.centerY.equalTo(safeAreaLayoutGuide)
        }
    }

    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let type = type else {
            assertionFailure("Field type not set.")
            return
        }
        delegate?.newInput(textField.text, for: type)
    }
}
