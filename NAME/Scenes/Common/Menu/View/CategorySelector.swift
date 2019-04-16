//
//  CategorySelector.swift
//  NAME
//
//  Created by E-Liang Tan on 16/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import UIKit

protocol CategorySelectorDelegate: class {
    func categorySelector(_ selector: CategorySelector,
                          didSelectCategory category: String,
                          atIndex index: Int)
}

private class CategoryButton: UIButton {
    var category: (name: String, index: Int) = ("", -1) {
        didSet {
            setTitle(category.name, for: .normal)
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .yellow
            } else {
                backgroundColor = .green
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isSelected = false
        setTitleColor(.black, for: .normal)
        contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CategorySelector: UIScrollView {
    private let categorySelector: UIStackView = {
        let selector = UIStackView()
        selector.spacing = ConstraintConstants.standardValue
        return selector
    }()

    weak var selectorDelegate: CategorySelectorDelegate?

    var categories: [String] = [] {
        didSet {
            categorySelector.subviews.forEach { $0.removeFromSuperview() }
            for (index, category) in categories.enumerated() {
                let button = CategoryButton()
                button.category = (category, index)
                button.addTarget(self, action: #selector(didSelectCategory(sender:)), for: .touchDown)
                categorySelector.addArrangedSubview(button)
                if let selectedIndex = selectedIndex, selectedIndex == index {
                    button.isSelected = true
                }
            }
        }
    }

    var selectedIndex: Int? {
        didSet {
            if let oldValue = oldValue,
                oldValue < categorySelector.arrangedSubviews.count,
                let button = categorySelector.arrangedSubviews[oldValue] as? CategoryButton {
                button.isSelected = false
            }
            if let selectedIndex = selectedIndex,
                selectedIndex < categorySelector.arrangedSubviews.count,
                let button = categorySelector.arrangedSubviews[selectedIndex] as? CategoryButton {
                button.isSelected = true
                scrollRectToVisible(button.frame, animated: false)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = true

        addSubview(categorySelector)

        categorySelector.translatesAutoresizingMaskIntoConstraints = false
        categorySelector.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didSelectCategory(sender: CategoryButton) {
        selectedIndex = sender.category.index
        if let selectedIndex = selectedIndex {
            selectorDelegate?.categorySelector(self,
                                               didSelectCategory: sender.category.name,
                                               atIndex: selectedIndex)
        }
    }
}
