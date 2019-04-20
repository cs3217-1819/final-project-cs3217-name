//
//  MenuDetailMediator.swift
//  NAME
//
//  Created by Julius on 17/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import Foundation

typealias MenuDetailMediatorMenuInfoInput = MenuInfoToParentOutput
typealias MenuDetailMediatorMenuInfoOutput = MenuInfoFromParentInput

typealias MenuDetailMediatorMenuAddonsInput = MenuAddonsToParentOutput
typealias MenuDetailMediatorMenuAddonsOutput = MenuAddonsFromParentInput

class MenuDetailIntersceneMediator: MenuDetailMediatorMenuInfoInput, MenuDetailMediatorMenuAddonsInput {
    weak var menuInfoInteractor: MenuDetailMediatorMenuInfoOutput?
    weak var menuAddonsInteractor: MenuDetailMediatorMenuAddonsOutput?

    func set(comment: String) {
        menuAddonsInteractor?.set(comment: comment)
    }

    func set(price: Int) {
        menuAddonsInteractor?.set(price: price)
    }
}
