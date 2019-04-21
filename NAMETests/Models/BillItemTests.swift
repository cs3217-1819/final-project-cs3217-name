//
//  BillItemTests.swift
//  NAMETests
//
//  Created by Derek Nam on 18/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import XCTest
@testable import NAME

class BillItemTests: XCTestCase {

    class OrderItemStub: OrderItemProtocol {
        var name: String = ""
        var originalPrice: Int = 5_000
        var discounts: [Discount] = []
        var price: Int = 5_000
    }

    func testBillItem_attributesSetCorrectly() {

        let itemMock = OrderItemStub()

        let billItem = BillItem(source: itemMock, discounts: [])

        XCTAssertEqual(billItem.originalPrice, 5_000)
        XCTAssertEqual(billItem.discountedPrice, 5_000)
        XCTAssertEqual(billItem.discounts, [])
        XCTAssertNil(billItem.containsStackableDiscounts)
    }

    // MARK: - Test Bill Item that contains (a) stackable discount(s)

    func testBillItem_StackableDiscounts_discountedPriceNonNegative() {
        let itemMock = OrderItemStub()

        let discount1 = Discount(name: "d1",
                                 priceModification: PriceModification.absolute(amount: 6_000),
                                 stackable: true,
                                 timeCondition: TimeCondition.dayRange(DateInterval()))

        let billItem = BillItem(source: itemMock, discounts: [discount1])

        XCTAssertEqual(billItem.originalPrice, 5_000)
        XCTAssertEqual(billItem.discountedPrice, 0)
        XCTAssertEqual(billItem.containsStackableDiscounts, Optional(true))
    }

    func testBillItem_StackableDiscounts_discountedPriceComputedCorrectly() {
        let itemMock = OrderItemStub()

        let discount1 = Discount(name: "d1",
                                 priceModification: PriceModification.absolute(amount: 1_000),
                                 stackable: true,
                                 timeCondition: TimeCondition.dayRange(DateInterval()))
        let discount2 = Discount(name: "d2",
                                 priceModification: PriceModification.multiplier(factor: 0.5),
                                 stackable: true,
                                 timeCondition: TimeCondition.dayRange(DateInterval()))

        let billItem = BillItem(source: itemMock, discounts: [discount1, discount2])

        XCTAssertEqual(billItem.originalPrice, 5_000)
        XCTAssertEqual(billItem.discountedPrice, 1_500)
        XCTAssertEqual(billItem.containsStackableDiscounts, Optional(true))
    }

    // MARK: - Test Bill Item that contains a non stackable discount

    func testBillItem_nonStackableDiscounts_discountedPriceNonNegative() {
        let itemMock = OrderItemStub()

        let discount1 = Discount(name: "d1",
                                 priceModification: PriceModification.absolute(amount: 6_000),
                                 stackable: false,
                                 timeCondition: TimeCondition.dayRange(DateInterval()))

        let billItem = BillItem(source: itemMock, discounts: [discount1])

        XCTAssertEqual(billItem.originalPrice, 5_000)
        XCTAssertEqual(billItem.discountedPrice, 0)
        XCTAssertEqual(billItem.containsStackableDiscounts, Optional(false))
    }

    func testBillItem_nonStackableDiscounts_discountedPriceComputedCorrectly() {
        let itemMock = OrderItemStub()

        let discount1 = Discount(name: "d1",
                                 priceModification: PriceModification.multiplier(factor: 0.4),
                                 stackable: false,
                                 timeCondition: TimeCondition.dayRange(DateInterval()))

        let billItem = BillItem(source: itemMock, discounts: [discount1])

        XCTAssertEqual(billItem.originalPrice, 5_000)
        XCTAssertEqual(billItem.discountedPrice, 3_000)
        XCTAssertEqual(billItem.containsStackableDiscounts, Optional(false))
    }
}
