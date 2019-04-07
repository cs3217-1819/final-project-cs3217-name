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
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        backgroundColor = .white
        addSubview(label)

        label.snp.makeConstraints { make in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
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
