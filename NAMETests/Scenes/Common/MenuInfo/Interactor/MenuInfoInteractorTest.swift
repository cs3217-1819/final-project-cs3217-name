//
//  MenuInfoInteractorTest.swift
//  NAMETests
//
//  Created by Julius on 21/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import XCTest
import RealmSwift
@testable import NAME

private let menuId = "5"

private final class StorageManagerStub: TestStorageManager {
    private let menuItem: MenuEditable = {
        let option = MenuItemOption(name: "Vegetable", options: .boolean(price: 500), defaultValue: .boolean(false))
        return IndividualMenuItem(name: "Never",
                                  details: "Gonna",
                                  price: 5_000,
                                  quantity: 1,
                                  addOns: [],
                                  options: [option])
    }()

    override func getMenuEditable(id: String) -> MenuEditable? {
        XCTAssertEqual(id, menuId)
        return menuItem
    }

    override func getMenuDisplayable(id: String) -> MenuDisplayable? {
        return getMenuEditable(id: id)
    }
}

private final class Output: MenuInfoInteractorOutput {
    var comment: String?
    var menuDisplayable: MenuDisplayable?

    func presentMenuDisplayable(_ menuDisplayable: MenuDisplayable) {
        self.menuDisplayable = menuDisplayable
    }

    func presentComment(_ comment: String) {
        self.comment = comment
    }
}

private final class Worker: MenuInfoWorker {

}

private final class TestDependencyInjector: DependencyInjector {
    let storageManager: StorageManager = StorageManagerStub()

    lazy var authManager: AuthManager = ProductionAuthManager(storageManager: storageManager)

    lazy var shoppingCart: ShoppingCart = ProductionShoppingCart(storageManager: storageManager)
}

class MenuInfoInteractorTest: XCTestCase {
    private let injector = TestDependencyInjector()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testComment() {
        let output = Output()
        let interactor = MenuInfoInteractor(output: output,
                                            menuId: menuId,
                                            injector: injector,
                                            toParentMediator: nil,
                                            worker: Worker())
        let comment = "Never gonna give you up"
        interactor.changeComment(comment)
        XCTAssertEqual(output.comment, comment)
    }

    func testChangeName() {
        let output = Output()
        let interactor = MenuInfoInteractor(output: output,
                                            menuId: menuId,
                                            injector: injector,
                                            toParentMediator: nil,
                                            worker: Worker())
        let name = "Rick Astley"
        interactor.changeName(name)
        XCTAssertEqual(output.menuDisplayable?.name, name)
    }

    func testChangeDetails() {
        let output = Output()
        let interactor = MenuInfoInteractor(output: output,
                                            menuId: menuId,
                                            injector: injector,
                                            toParentMediator: nil,
                                            worker: Worker())
        let details = "You have been rickrolled"
        interactor.changeDetails(details)
        XCTAssertEqual(output.menuDisplayable?.details, details)
    }

    func testChangePrice() {
        let output = Output()
        let interactor = MenuInfoInteractor(output: output,
                                            menuId: menuId,
                                            injector: injector,
                                            toParentMediator: nil,
                                            worker: Worker())
        let priceString = "0.42"
        guard let price = priceString.asPriceInt() else {
            XCTFail("Invalid priceString used")
            return
        }
        interactor.changePrice(priceString)
        XCTAssertEqual(output.menuDisplayable?.price, price)
    }

    func testLoadMenuDisplayable() {
        let menuDisplayable = injector.storageManager.getMenuDisplayable(id: menuId)
        let output = Output()
        let interactor = MenuInfoInteractor(output: output,
                                            menuId: menuId,
                                            injector: injector,
                                            toParentMediator: nil,
                                            worker: Worker())
        interactor.loadMenuDisplayable()
        XCTAssertEqual(menuDisplayable?.id, output.menuDisplayable?.id)
        XCTAssertEqual(menuDisplayable?.name, output.menuDisplayable?.name)
        XCTAssertEqual(menuDisplayable?.details, output.menuDisplayable?.details)
        XCTAssertEqual(menuDisplayable?.imageURL, output.menuDisplayable?.imageURL)
        XCTAssertEqual(menuDisplayable?.isHidden, output.menuDisplayable?.isHidden)
        XCTAssertEqual(menuDisplayable?.quantity, output.menuDisplayable?.quantity)
    }
}
