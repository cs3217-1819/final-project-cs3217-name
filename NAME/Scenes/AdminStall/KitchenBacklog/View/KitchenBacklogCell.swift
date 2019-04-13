//
//  KitchenBacklogCell.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

protocol KitchenBacklogCellDelegate: class {
    func didTapCompleted(forCell cell: UICollectionViewCell)
    func didTapAllReady(forCell cell: UICollectionViewCell)
}

final class KitchenBacklogCell: UICollectionViewCell {
    private var isOrderReady = false

    private lazy var orderHeaderView = KitchenBacklogCellHeaderView()
    private var orderView: UIView?

    private var activeButton: UIButton {
        return isOrderReady ? orderCompleteButton : allReadyButton
    }

    private lazy var allReadyButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleAllReadyPress(sender:)), for: .touchUpInside)
        button.setTitle(KitchenBacklogConstants.orderReadyButtonTitle, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.backgroundColor = .purple
        return button
    }()

    private lazy var orderCompleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleCompletedPress(sender:)), for: .touchUpInside)
        button.setTitle(KitchenBacklogConstants.orderCompleteButtonTitle, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.backgroundColor = .green
        return button
    }()

    weak var delegate: KitchenBacklogCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func set(headerTitle: String, isOrderReady: Bool, orderView: UIView?) {
        orderHeaderView.set(title: headerTitle)
        self.orderView = orderView
        self.isOrderReady = isOrderReady

        addSubviews()
        configureConstraints()
    }

    private func addSubviews() {
        addSubview(orderHeaderView)
        addSubview(activeButton)
        guard let orderView = orderView else {
                assertionFailure("Order view not set.")
                return
        }
        addSubview(orderView)
    }

    private func configureConstraints() {
        orderHeaderView.snp.remakeConstraints { make in
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(OrderConstants.headerHeight)
        }

        activeButton.snp.remakeConstraints { make in
            make.height.equalTo(ButtonConstants.mediumButtonHeight)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        orderView?.snp.remakeConstraints { make in
            make.top.equalTo(orderHeaderView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(activeButton.snp.top)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        orderView?.removeFromSuperview()
        orderView = nil
    }

    @objc
    private func handleAllReadyPress(sender: Any) {
        delegate?.didTapAllReady(forCell: self)
    }

    @objc
    private func handleCompletedPress(sender: Any) {
        delegate?.didTapCompleted(forCell: self)
    }
}
