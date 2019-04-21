//
//  MenuAddonsTableViewHeaderView.swift
//  NAME
//
//  Created by Julius on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

protocol MenuAddonsTableViewHeaderViewDelegate: class {
    func resetButtonDidTap(section: Int)
    func reorderUpButtonDidTap(section: Int)
    func reorderDownButtonDidTap(section: Int)
}

class MenuAddonsTableViewHeaderView: UITableViewHeaderFooterView {
    weak var delegate: MenuAddonsTableViewHeaderViewDelegate?

    private var section: Int = 0

    private lazy var resetButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle(MenuAddonsConstants.sectionResetButtonTitle, for: .normal)
        result.setTitleColor(UIColor.Custom.salmonRed, for: .normal)
        result.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
        return result
    }()

    private lazy var reorderUpButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle(MenuAddonsConstants.reorderUp, for: .normal)
        result.addTarget(self, action: #selector(reorderUpButtonDidTap), for: .touchUpInside)
        return result
    }()

    private lazy var reorderDownButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle(MenuAddonsConstants.reorderDown, for: .normal)
        result.addTarget(self, action: #selector(reorderDownButtonDidTap), for: .touchUpInside)
        return result
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(resetButton)
        contentView.addSubview(reorderUpButton)
        contentView.addSubview(reorderDownButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureConstraints()
    }

    private func configureConstraints() {
        guard let textLabel = textLabel else {
            return
        }
        resetButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-ConstraintConstants.standardValue)
            make.centerY.equalTo(textLabel)
        }
        reorderDownButton.snp.remakeConstraints { make in
            make.centerY.equalTo(textLabel)
            make.trailing.equalTo(resetButton.snp.leading).offset(-ConstraintConstants.standardValue)
        }
        reorderUpButton.snp.remakeConstraints { make in
            make.centerY.equalTo(textLabel)
            make.trailing.equalTo(reorderDownButton.snp.leading).offset(-ConstraintConstants.standardValue)
        }
    }

    func set(section: Int, title: String, isResettable: Bool, isReorderable: Bool) {
        self.section = section
        textLabel?.text = title
        resetButton.isHidden = !isResettable
        reorderUpButton.isHidden = !isReorderable
        reorderDownButton.isHidden = !isReorderable
    }

    @objc
    private func resetButtonDidTap() {
        delegate?.resetButtonDidTap(section: section)
    }

    @objc
    private func reorderUpButtonDidTap() {
        delegate?.reorderUpButtonDidTap(section: section)
    }

    @objc
    private func reorderDownButtonDidTap() {
        delegate?.reorderDownButtonDidTap(section: section)
    }
}
