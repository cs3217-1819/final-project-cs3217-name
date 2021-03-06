//
//  MenuViewModel.swift
//  NAME
//
//  Created by E-Liang Tan on 28/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

enum MenuCategoryAction {
    case insertLeft
    case insertRight
    case rename
    case remove
}

struct MenuViewModel {
    struct MenuStallViewModel {
        let name: String
    }

    struct MenuDiscountViewModel {
        let name: String
        // TODO: Display price modification
    }

    struct MenuItemViewModel {
        let id: String
        let name: String
        let imageURL: String?
        let price: Int
        let discounts: [MenuDiscountViewModel]
    }

    struct MenuCategoryViewModel {
        let name: String
        let items: [MenuItemViewModel]
    }

    let stall: MenuStallViewModel
    let categories: [MenuCategoryViewModel]
}
