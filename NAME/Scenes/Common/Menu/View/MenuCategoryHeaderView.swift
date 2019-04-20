//
//  MenuCategoryHeaderView.swift
//  NAME
//
//  Created by E-Liang Tan on 7/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

class MenuCategoryHeaderView: UICollectionReusableView {
    private let label = UILabel()

    // Apparently the headerview is above the scrollbar of the collection view
    // so this will be the workaround until it's solved :(
    override var layer: CALayer {
        let layer = super.layer
        layer.zPosition = 0
        return layer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.Custom.paleGray
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
