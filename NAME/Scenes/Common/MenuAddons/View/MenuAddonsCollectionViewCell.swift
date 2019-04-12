//
//  MenuAddonsCollectionViewCell.swift
//  NAME
//
//  Created by Julius on 10/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

final class MenuAddonsCollectionViewCell: UICollectionViewCell {
    // TODO use real image
    private let imageView: UIImageView = {
        let result = UIImageView(frame: .zero)
        result.backgroundColor = .gray
        return result
    }()
    private let nameLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.textAlignment = .center
        result.font = .preferredFont(forTextStyle: .callout)
        return result
    }()
    private let priceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.textAlignment = .center
        result.font = .preferredFont(forTextStyle: .subheadline)
        result.textColor = .gray
        return result
    }()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                nameLabel.textColor = .red
            } else {
                nameLabel.textColor = .black
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        configureConstraints()
    }

    private func configureConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(ConstraintConstants.standardValue)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(ConstraintConstants.standardValue)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(name: String, price: String) {
        nameLabel.text = name
        priceLabel.text = price
    }
}
