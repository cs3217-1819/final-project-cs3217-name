//
//  CustomerRootIntersceneMediator.swift
//  NAME
//
//  Created by E-Liang Tan on 20/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

typealias CustomerRootIntersceneMediatorSelfInput = CustomerRootToChildrenOutput
typealias CustomerRootIntersceneMediatorSelfOutput = CustomerRootFromChildrenInput

typealias CustomerRootIntersceneMediatorBrowseInput = BrowseToParentOutput
typealias CustomerRootIntersceneMediatorBrowseOutput = BrowseFromParentInput

class CustomerRootIntersceneMediator: CustomerRootIntersceneMediatorSelfInput,
CustomerRootIntersceneMediatorBrowseInput {
    weak var selfInteractor: CustomerRootIntersceneMediatorSelfOutput?
    weak var browseInteractor: CustomerRootIntersceneMediatorBrowseOutput?

    func requestSessionEnd() {
        selfInteractor?.requestSessionEnd()
    }
}
