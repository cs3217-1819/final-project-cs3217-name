//
//  MenuIntersceneMediator.swift
//  NAME
//
//  Created by E-Liang Tan on 21/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

typealias MenuIntersceneMediatorSelfInput = MenuToChildrenOutput
typealias MenuIntersceneMediatorSelfOutput = MenuFromChildrenInput

typealias MenuIntersceneMediatorMenuDetailInput = MenuDetailToParentOutput
typealias MenuIntersceneMediatorMenuDetailOutput = MenuDetailFromParentInput

class MenuIntersceneMediator: MenuIntersceneMediatorSelfInput,
MenuIntersceneMediatorMenuDetailInput {
    weak var selfInteractor: MenuIntersceneMediatorSelfOutput?
    weak var menuDetailInteractor: MenuIntersceneMediatorMenuDetailOutput?

    func handleNewMenuItem(id: String) {
        selfInteractor?.handleNewMenuItem(id: id)
    }
}
