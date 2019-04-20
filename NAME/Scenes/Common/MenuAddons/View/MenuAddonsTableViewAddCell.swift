//
//  MenuAddonsTableViewAddCell.swift
//  NAME
//
//  Created by Julius on 20/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

protocol MenuAddonsTableViewAddCellDelegate: class {
    func addButtonDidTap(sender: UIButton)
}

class MenuAddonsTableViewAddCell: UITableViewCell {
    static let reuseIdentifier = String(describing: type(of: self))

    private lazy var addButton: UIButton = {
        let result = UIButton(type: .system)
        result.backgroundColor = UIColor.Custom.paleGray
        result.setTitleColor(UIColor.Custom.purple, for: .normal)
        result.setTitle(MenuAddonsConstants.addChoiceButtonTitle, for: .normal)
        result.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        result.addTarget(self, action: #selector(addButtonDidTap(sender:)), for: .touchUpInside)
        return result
    }()

    weak var delegate: MenuAddonsTableViewAddCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(addButton)
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc
    private func addButtonDidTap(sender: UIButton) {
        delegate?.addButtonDidTap(sender: sender)
    }
}
