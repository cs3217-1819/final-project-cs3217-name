//
//  StallListCustomerCell.swift
//  NAME
//
//  Created by E-Liang Tan on 30/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class StallListCustomerCell: UICollectionViewCell {
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .boldSystemFont(ofSize: StallListConstants.titleFontSize)
        return textLabel
    }()

    private let detailTextLabel = UILabel()

    private lazy var contentContainer: UIStackView = {
        // TODO: add stall image
        let stackView = UIStackView(arrangedSubviews: [textLabel, detailTextLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

    var viewModel: StallListViewModel.StallViewModel? {
        didSet {
            // TODO: Update stall image
            textLabel.text = viewModel?.name
            detailTextLabel.text = viewModel?.location
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                textLabel.textColor = .purple
                detailTextLabel.textColor = .purple
            } else {
                textLabel.textColor = .black
                detailTextLabel.textColor = .black
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(contentContainer)
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configureConstraints() {
        contentContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(textLabel)
            make.bottom.equalTo(detailTextLabel)
        }
    }
}
