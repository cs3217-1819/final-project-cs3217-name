//
//  KitchenBacklogViewModel.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

struct KitchenBacklogViewModel {
    let orders: [OrderViewModel]
}

struct OrderViewModel {
    let title: String
    let orderItems: [OrderItemViewModel]
}

struct OrderItemViewModel {
    let name: String
    let quantity: Int
    let comment: String
    // TODO: To also handle dining option and addons
}
