//
//  MenuAddonsCollectionViewAddCell.swift
//  NAME
//
//  Created by Julius on 20/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

protocol MenuAddonsCollectionViewAddCellDelegate: class {
    func addButtonDidTap()
}

class MenuAddonsCollectionViewAddCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: type(of: self))

    private lazy var addButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle(MenuAddonsConstants.addChoiceButtonTitle, for: .normal)
        result.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        result.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        return result
    }()

    weak var delegate: MenuAddonsCollectionViewAddCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

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
    private func addButtonDidTap() {
        delegate?.addButtonDidTap()
    }
}
