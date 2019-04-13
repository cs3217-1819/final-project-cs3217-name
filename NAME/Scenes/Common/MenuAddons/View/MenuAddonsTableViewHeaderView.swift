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
}

class MenuAddonsTableViewHeaderView: UITableViewHeaderFooterView {
    weak var delegate: MenuAddonsTableViewHeaderViewDelegate?

    private let button: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle(MenuAddonsConstants.sectionResetButtonTitle, for: .normal)
        result.setTitleColor(.red, for: .normal)
        result.addTarget(self, action: #selector(resetButtonDidTap), for: .touchUpInside)
        return result
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(button)
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
        button.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-ConstraintConstants.standardValue)
            make.centerY.equalTo(textLabel)
        }
    }

    func set(section: Int, title: String) {
        button.tag = section
        textLabel?.text = title
    }

    @objc
    private func resetButtonDidTap() {
        delegate?.resetButtonDidTap(section: button.tag)
    }
}
