//
//  KitchenBacklogViewModel.swift
//  NAME
//
//  Created by Caryn Heng on 30/3/19.
//  Copyright (c) 2019 NAME. All rights reserved.
//

import UIKit

struct KitchenBacklogViewModel {
    struct OrderViewModel {
        let orderId: String
        let title: String
        let timeStamp: Date
    }
    let preparedOrders: [OrderViewModel]
    let unpreparedOrders: [OrderViewModel]
}
