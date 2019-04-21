//
//  MenuEditable.swift
//  NAME
//
//  Created by E-Liang Tan on 17/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

protocol MenuEditable: MenuDisplayable {
    func add(category: MenuCategory)
    func remove(category: MenuCategory)
    func removeAllCategories()
}

extension MenuEditable {
    func add(category: MenuCategory) {
        categories.append(category)
    }

    func remove(category: MenuCategory) {
        if let index = categories.index(of: category) {
            categories.remove(at: index)
        }
    }

    func removeAllCategories() {
        categories.removeAll()
    }
}
