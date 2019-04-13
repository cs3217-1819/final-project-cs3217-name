//
//  OrderViewModel.swift
//  NAME
//
//  Created by Caryn Heng on 10/4/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

struct OrderViewModel {
    struct OrderItemViewModel {
        let name: String
        let quantity: String
        let diningOption: String
        let options: String
        let addons: String
        let comment: String
    }

    let id: String
    let preparedOrderItems: [OrderItemViewModel]
    let unpreparedOrderItems: [OrderItemViewModel]
}
