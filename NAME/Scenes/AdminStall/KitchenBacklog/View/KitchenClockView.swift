//
//  KitchenClockView.swift
//  NAME
//
//  Created by Caryn Heng on 20/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class KitchenClockView: UIView {

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        styleClock()
        addSubview(label)
        configureConstraints()
        updateTime()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This should not be called without Storyboard.")
    }

    private func configureConstraints() {
        label.snp_makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
            make.left.equalTo(safeAreaLayoutGuide).offset(ConstraintConstants.standardValue)
            make.right.equalTo(safeAreaLayoutGuide).offset(-ConstraintConstants.standardValue)
        }
    }

    func updateTime() {
        let now = Date()
        label.text = now.formattedAsTime()
    }

    private func styleClock() {
        backgroundColor = UIColor.Custom.deepPurple
        clipsToBounds = true
        layer.cornerRadius = CornerRadiusConstants.standardRadius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
