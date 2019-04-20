//
//  BrowseIntersceneMediator.swift
//  NAME
//
//  Created by E-Liang Tan on 1/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

typealias BrowseIntersceneMediatorSelfInput = BrowseToChildrenOutput
typealias BrowseIntersceneMediatorSelfOutput = BrowseFromChildrenInput

typealias BrowseIntersceneMediatorStallListInput = StallListToParentOutput
typealias BrowseIntersceneMediatorStallListOutput = StallListFromParentInput

typealias BrowseIntersceneMediatorMenuInput = MenuToParentOutput
typealias BrowseIntersceneMediatorMenuOutput = MenuFromParentInput

class BrowseIntersceneMediator: BrowseIntersceneMediatorSelfInput,
BrowseIntersceneMediatorStallListInput, BrowseIntersceneMediatorMenuInput {
    weak var selfInteractor: BrowseFromChildrenInput?
    weak var stallListInteractor: BrowseIntersceneMediatorStallListOutput?
    weak var menuInteractor: BrowseIntersceneMediatorMenuOutput?

    weak var selectedStall: Stall? {
        didSet {
            self.menuInteractor?.stall = selectedStall
        }
    }

    func requestSessionEnd() {
        selfInteractor?.requestSessionEnd()
    }
}
