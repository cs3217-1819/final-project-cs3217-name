//
//  KitchenBacklogCellHeaderView.swift
//  NAME
//
//  Created by Caryn Heng on 5/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class KitchenBacklogCellHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Custom.darkPurple
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .right
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, timerLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    func set(title: String) {
        titleLabel.text = title
    }

    func set(timer: String) {
        timerLabel.text = timer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func addSubviews() {
        addSubview(stackView)
    }

    private func configureConstraints() {
        stackView.snp.remakeConstraints { make in
            make.height.equalToSuperview()
            make.left.equalToSuperview().offset(OrderConstants.headerPadding)
            make.right.equalToSuperview().offset(-OrderConstants.headerPadding)
        }
    }

}
