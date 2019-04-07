//
//  MenuItemCollectionViewCell.swift
//  NAME
//
//  Created by E-Liang Tan on 7/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
    private let nameLabel = UILabel()

    func set(name: String) {
        nameLabel.text = name
    }

    override func layoutSubviews() {
        backgroundColor = .gray

        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        snp.makeConstraints { make in
            make.size.equalTo(nameLabel)
        }
    }
}
