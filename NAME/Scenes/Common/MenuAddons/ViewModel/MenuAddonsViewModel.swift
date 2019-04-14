//
//  MenuAddonsViewModel.swift
//  NAME
//
//  Created by Julius on 9/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

struct MenuAddonsViewModel {
    struct MenuOptionViewModel {
        let name: String
        let type: MenuOptionTypeViewModel
        let value: MenuOptionValueViewModel
    }
    enum MenuOptionValueViewModel {
        case quantity(Int)
        case choice(String)
    }
    enum MenuOptionTypeViewModel {
        case quantity(price: String)
        case choices([(name: String, price: String)])
    }
    let options: [MenuOptionViewModel]
    let totalPrice: String
    let quantity: Int
}
