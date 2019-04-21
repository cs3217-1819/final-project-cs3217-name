//
//  MenuAddonsTableViewChoiceCell.swift
//  NAME
//
//  Created by Julius on 13/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation
import UIKit

protocol MenuAddonsTableViewChoiceCellDelegate: class {
    func collectionViewDidLongPress(_ collectionView: UICollectionView, gesture: UILongPressGestureRecognizer)
    func collectionViewDidTap(_ collectionView: UICollectionView, gesture: UITapGestureRecognizer)
}

class MenuAddonsTableViewChoiceCell: UITableViewCell {
    static let reuseIdentifier = String(describing: type(of: self))
    private let collectionViewCellIdentifier: String = "collectionViewCellIdentifier"

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = MenuAddonsConstants.addonsSize
        let result = UICollectionView(frame: .zero, collectionViewLayout: layout)
        result.register(MenuAddonsCollectionViewCell.self,
                        forCellWithReuseIdentifier: MenuAddonsCollectionViewCell.reuseIdentifier)
        result.register(MenuAddonsCollectionViewAddCell.self,
                        forCellWithReuseIdentifier: MenuAddonsCollectionViewAddCell.reuseIdentifier)
        result.backgroundColor = MenuAddonsConstants.backgroundColor
        result.allowsMultipleSelection = true
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(collectionViewDidLongPress(gesture:)))
        result.addGestureRecognizer(longPressRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(collectionViewDidTap(gesture:)))
        result.addGestureRecognizer(tapRecognizer)
        return result
    }()

    private weak var delegate: MenuAddonsTableViewChoiceCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(collectionView)
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    func set(dataSourceDelegate: MenuAddonsCollectionViewDataSourceDelegate) {
        delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
        collectionView.reloadData()
    }

    @objc
    private func collectionViewDidLongPress(gesture: UILongPressGestureRecognizer) {
        delegate?.collectionViewDidLongPress(collectionView, gesture: gesture)
    }

    @objc
    private func collectionViewDidTap(gesture: UITapGestureRecognizer) {
        delegate?.collectionViewDidTap(collectionView, gesture: gesture)
    }
}
