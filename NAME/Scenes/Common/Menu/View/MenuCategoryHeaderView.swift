//
//  MenuCategoryHeaderView.swift
//  NAME
//
//  Created by E-Liang Tan on 7/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class MenuCategoryHeaderView: UICollectionReusableView {
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
}
