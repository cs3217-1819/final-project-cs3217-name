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
            updateDisplayFromState()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateDisplayFromState()
        }
    }

    var isRemoveTarget: Bool {
        didSet {
            updateDisplayFromState()
        }
    }

    override init(frame: CGRect) {
        isRemoveTarget = false
        super.init(frame: frame)
        isSelected = false
        setTitleColor(.black, for: .normal)
        contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateDisplayFromState() {
        if isRemoveTarget {
            backgroundColor = .red
            setTitle("Remove", for: .normal)
        } else if isSelected {
            backgroundColor = .yellow
            setTitle(category.name, for: .normal)
        } else {
            backgroundColor = .green
            setTitle(category.name, for: .normal)
        }
    }
}

class CategorySelector: UIScrollView {
    private let categorySelector: UIStackView = {
        let selector = PassthroughStackView()
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
                button.isRemoveTarget = false
            }
            if let selectedIndex = selectedIndex,
                selectedIndex < categorySelector.arrangedSubviews.count,
                let button = categorySelector.arrangedSubviews[selectedIndex] as? CategoryButton {
                button.isSelected = !isRemoving
                button.isRemoveTarget = isRemoving
                scrollRectToVisible(button.frame, animated: false)
            }
        }
    }

    var isRemoving: Bool {
        didSet {
            let removeIndex = selectedIndex
            selectedIndex = removeIndex
        }
    }

    var isSelectionEnabled: Bool {
        didSet {
            for case let button as CategoryButton in categorySelector.arrangedSubviews {
                button.isEnabled = isSelectionEnabled
            }
        }
    }

    override init(frame: CGRect) {
        isRemoving = false
        isSelectionEnabled = true
        super.init(frame: frame)
        alwaysBounceHorizontal = true
        showsHorizontalScrollIndicator = true

        addSubview(categorySelector)

        categorySelector.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func categoryInfo(atPoint point: CGPoint) -> (index: Int, isRemove: Bool)? {
        guard let categoryButton = categorySelector.hitTest(point, with: nil) as? CategoryButton else {
            return nil
        }

        let categoryIndex = categoryButton.category.index
        guard 0..<categories.count ~= categoryIndex else {
            return nil
        }

        var isRemove = false
        if let selectedIndex = selectedIndex {
            isRemove = isRemoving && selectedIndex == categoryIndex
        }
        return (categoryIndex, isRemove)
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
