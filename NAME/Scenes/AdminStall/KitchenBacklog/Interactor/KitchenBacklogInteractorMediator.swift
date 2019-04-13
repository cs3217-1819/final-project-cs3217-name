//
//  KitchenBacklogInteractorMediator.swift
//  NAME
//
//  Created by Caryn Heng on 11/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

typealias KitchenBacklogIntersceneMediatorOrderInput = OrderToParentOutput
typealias KitchenBacklogIntersceneMediatorOrderOutput = OrderFromParentInput

typealias KitchenBacklogIntersceneMediatorKitchenBacklogInput = KitchenBacklogToChildrenOutput
typealias KitchenBacklogIntersceneMediatorKitchenBacklogOutput = KitchenBacklogFromChildrenInput

class KitchenBacklogIntersceneMediator: KitchenBacklogIntersceneMediatorOrderInput,
KitchenBacklogIntersceneMediatorKitchenBacklogInput {
    weak var orderInteractor: KitchenBacklogIntersceneMediatorOrderOutput?
    weak var kitchenBacklogInteractor: KitchenBacklogIntersceneMediatorKitchenBacklogOutput?

    func handleOrderReady() {
        kitchenBacklogInteractor?.handleAllOrderItemsReady()
    }
}
