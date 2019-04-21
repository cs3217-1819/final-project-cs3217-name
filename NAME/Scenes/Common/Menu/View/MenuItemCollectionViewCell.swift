//
//  MenuItemCollectionViewCell.swift
//  NAME
//
//  Created by E-Liang Tan on 7/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.Custom.lightGray

        addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(name: String) {
        nameLabel.text = name
    }
}
