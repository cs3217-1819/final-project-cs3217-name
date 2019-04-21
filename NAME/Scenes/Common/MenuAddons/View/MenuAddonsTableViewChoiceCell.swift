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
    func collectionViewDidDoubleTap(_ collectionView: UICollectionView, gesture: UITapGestureRecognizer)
    var shouldPreferSingleTap: Bool { get }
}

class MenuAddonsTableViewChoiceCell: UITableViewCell {
    static let reuseIdentifier = String(describing: type(of: self))
    private let collectionViewCellIdentifier: String = "collectionViewCellIdentifier"

    private lazy var longPressRecognizer: UILongPressGestureRecognizer = {
        let result = UILongPressGestureRecognizer(target: self,
                                                  action: #selector(collectionViewDidLongPress(gesture:)))
        result.delegate = self
        return result
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let result = UITapGestureRecognizer(target: self,
                                            action: #selector(collectionViewDidTap(gesture:)))
        result.delegate = self
        return result
    }()

    private lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let result = UITapGestureRecognizer(target: self,
                                            action: #selector(collectionViewDidDoubleTap(gesture:)))
        result.numberOfTapsRequired = 2
        result.delegate = self
        return result
    }()

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
        result.addGestureRecognizer(longPressRecognizer)
        result.addGestureRecognizer(tapRecognizer)
        result.addGestureRecognizer(doubleTapRecognizer)
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

    @objc
    private func collectionViewDidDoubleTap(gesture: UITapGestureRecognizer) {
        delegate?.collectionViewDidDoubleTap(collectionView, gesture: gesture)
    }

    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let shouldPreferSingleTap = delegate?.shouldPreferSingleTap else {
            return false
        }
        if gestureRecognizer == tapRecognizer && otherGestureRecognizer == doubleTapRecognizer && shouldPreferSingleTap {
            return true
        }
        return false
    }
}
