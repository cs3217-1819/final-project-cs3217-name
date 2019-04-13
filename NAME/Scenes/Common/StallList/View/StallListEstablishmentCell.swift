//
//  StallListEstablishmentCell.swift
//  NAME
//
//  Created by Caryn Heng on 6/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

protocol StallListTableViewCellDelegate: class {
    func didTapEdit()
    func didTapDelete(at cell: UICollectionViewCell)
}

class StallListEstablishmentCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .boldSystemFont(ofSize: StallListConstants.titleFontSize)
        return textLabel
    }()

    private let detailTextLabel = UILabel()

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleEditPress(sender:)), for: .touchUpInside)
        button.setTitle(StallListConstants.editButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .purple
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleDeletePress(sender:)), for: .touchUpInside)
        button.setTitle(StallListConstants.deleteButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .lightGray
        return button
    }()

    private lazy var actionsContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, editButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    var viewModel: StallListViewModel.StallViewModel? {
        didSet {
            // TODO: Update stall image
            textLabel.text = viewModel?.name
            detailTextLabel.text = viewModel?.location
        }
    }

    weak var delegate: StallListTableViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func addSubviews() {
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(detailTextLabel)
        addSubview(actionsContainer)
    }

    private func configureConstraints() {
        actionsContainer.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(ButtonConstants.mediumButtonHeight)
            make.bottom.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(StallListConstants.cellPadding)
            make.right.equalToSuperview().offset(-StallListConstants.cellPadding)
            make.bottom.equalTo(detailTextLabel.snp.top).offset(-StallListConstants.cellPadding)
        }

        detailTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(StallListConstants.cellPadding)
            make.right.equalToSuperview().offset(-StallListConstants.cellPadding)
            make.bottom.equalTo(actionsContainer.snp.top).offset(-StallListConstants.cellPadding)
        }

        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(textLabel.snp.top).offset(-StallListConstants.cellPadding)
        }
    }

    @objc
    private func handleEditPress(sender: UIButton) {
        delegate?.didTapEdit()
    }

    @objc
    private func handleDeletePress(sender: UIButton) {
        delegate?.didTapDelete(at: self)
    }
}
