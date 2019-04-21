//
//  OrderToBillProcessorTests.swift
//  NAMETests
//
//  Created by Derek Nam on 18/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import XCTest
@testable import NAME

class OrderToBillProcessorTests: XCTestCase {

    class OrderStub: OrderProtocol {
        var orderItems: [OrderItemProtocol] = []
        var establishmentDiscounts: [Discount]?
        var establishmentSurcharges: [Surcharge]?
    }

    class OrderItemStub: OrderItemProtocol {
        var name: String
        var originalPrice: Int
        var discounts: [Discount]
        init(name: String = "", originalPrice: Int = 5_000, discounts: [Discount] = []) {
            self.name = name
            self.originalPrice = originalPrice
            self.discounts = discounts
        }
    }

    let discount1 = Discount(name: "d1",
                             priceModification: PriceModification.absolute(amount: 2_000),
                             stackable: true,
                             timeCondition: TimeCondition.dayRange(DateInterval()))

    let discount2 = Discount(name: "d2",
                             priceModification: PriceModification.multiplier(factor: 0.2),
                             stackable: true,
                             timeCondition: TimeCondition.dayRange(DateInterval()))

    let discount3 = Discount(name: "d3",
                             priceModification: PriceModification.multiplier(factor: 0.5),
                             stackable: false,
                             timeCondition: TimeCondition.dayRange(DateInterval()))

    let discount4 = Discount(name: "d4",
                             priceModification: PriceModification.absolute(amount: 1_000),
                             stackable: false,
                             timeCondition: TimeCondition.dayRange(DateInterval()))

    let discount5 = Discount(name: "d5",
                             priceModification: PriceModification.absolute(amount: 7_000),
                             stackable: false,
                             timeCondition: TimeCondition.dayRange(DateInterval()))

    let surcharge1 = Surcharge(name: "s1", priceModification: .multiplier(factor: 0.1))
    let surcharge2 = Surcharge(name: "s2", priceModification: .multiplier(factor: 0.07))

    func testProcessor_ReturnsNilWhenOrderItemsEmpty() {
        let order = OrderStub()
        let billResult = OrderToBillProcessor.process(order: order)
        XCTAssertNil(billResult)
    }

    func testProcessor_ReturnsNoEstablishmentDiscountsCorrectly() {
        let order = OrderStub()

        order.orderItems.append(OrderItemStub(name: "item1",
                                              originalPrice: 4_000,
                                              discounts: [discount1, discount3]))
        order.orderItems.append(OrderItemStub(name: "item2",
                                              originalPrice: 4_800,
                                              discounts: [discount1, discount3]))
        let billResult = OrderToBillProcessor.process(order: order)

        XCTAssertEqual(billResult?.items.count, 2)
        XCTAssertEqual(billResult?.items[0].discountedPrice, 2_000)
        XCTAssertEqual(billResult?.items[1].discountedPrice, 2_400)
    }

    func testProcessor_WithEstablishmentDiscounts_NoSurcharges() {
        let order = OrderStub()
        order.establishmentDiscounts = [discount1, discount2]

        order.orderItems.append(OrderItemStub(name: "item1",
                                              originalPrice: 3_800,
                                              discounts: [discount1, discount3]))
        order.orderItems.append(OrderItemStub(name: "item2",
                                              originalPrice: 4_800,
                                              discounts: [discount1, discount3]))
        let billResult = OrderToBillProcessor.process(order: order)

        XCTAssertEqual(billResult?.items.count, 2)
        XCTAssertEqual(billResult?.items[0].containsStackableDiscounts, true)
        XCTAssertEqual(billResult?.items[0].discountedPrice, 1_800)
        XCTAssertEqual(billResult?.items[1].discountedPrice, 2_400)

        XCTAssertEqual(billResult?.grandTotal, 2_400)
    }

    func testProcessor_WithEstablishmentDiscounts_BestNonStackable() {
        let order = OrderStub()
        order.establishmentDiscounts = [discount1, discount2, discount3, discount4, discount5]

        order.orderItems.append(OrderItemStub(name: "item1",
                                              originalPrice: 3_800,
                                              discounts: [discount1, discount3]))
        order.orderItems.append(OrderItemStub(name: "item2",
                                              originalPrice: 4_800,
                                              discounts: [discount1, discount3]))
        let billResult = OrderToBillProcessor.process(order: order)

        XCTAssertEqual(billResult?.items.count, 2)
        XCTAssertEqual(billResult?.items[0].containsStackableDiscounts, nil)
        XCTAssertEqual(billResult?.items[1].containsStackableDiscounts, nil)
        XCTAssertEqual(billResult?.items[0].discountedPrice, 3_800)
        XCTAssertEqual(billResult?.items[1].discountedPrice, 4_800)

        XCTAssertEqual(billResult?.grandTotal, 1_600)
    }

    func testProcessor_WithEstablishmentDiscounts_BestStackable() {
        let order = OrderStub()
        order.establishmentDiscounts = [discount1, discount2, discount3, discount4]

        order.orderItems.append(OrderItemStub(name: "item1",
                                              originalPrice: 3_800,
                                              discounts: [discount1, discount2, discount3]))
        order.orderItems.append(OrderItemStub(name: "item2",
                                              originalPrice: 4_800,
                                              discounts: [discount1, discount3]))
        let billResult = OrderToBillProcessor.process(order: order)

        XCTAssertEqual(billResult?.items.count, 2)
        XCTAssertEqual(billResult?.items[0].containsStackableDiscounts, true)
        XCTAssertEqual(billResult?.items[1].containsStackableDiscounts, false)
        XCTAssertEqual(billResult?.items[0].discountedPrice, 1_050)
        XCTAssertEqual(billResult?.items[1].discountedPrice, 2_400)
        XCTAssertEqual(billResult?.establishmentDiscounts.count, 2)
        XCTAssertEqual(billResult?.establishmentDiscounts.first?.stackable, true)

        XCTAssertEqual(billResult?.grandTotal, 2_400)
    }

    func testProcessor_WithEstablishmentDiscounts_BestNoEstDiscounts() {
        let order = OrderStub()
        order.establishmentDiscounts = [discount1, discount2, discount3]

        order.orderItems.append(OrderItemStub(name: "item1",
                                              originalPrice: 3_800,
                                              discounts: [discount5]))
        order.orderItems.append(OrderItemStub(name: "item2",
                                              originalPrice: 4_800,
                                              discounts: [discount5]))
        let billResult = OrderToBillProcessor.process(order: order)

        XCTAssertEqual(billResult?.items.count, 2)
        XCTAssertEqual(billResult?.items[0].containsStackableDiscounts, false)
        XCTAssertEqual(billResult?.items[1].containsStackableDiscounts, false)
        XCTAssertEqual(billResult?.items[0].discountedPrice, 0)
        XCTAssertEqual(billResult?.items[1].discountedPrice, 0)
        XCTAssertEqual(billResult?.establishmentDiscounts.count, 0)

        XCTAssertEqual(billResult?.grandTotal, 0)
    }

    func testProcessor_WithEstablishmentDiscountsSurcharges() {
        let order = OrderStub()
        order.establishmentDiscounts = [discount1, discount2, discount3, discount4]
        order.establishmentSurcharges = [surcharge1, surcharge2]

        order.orderItems.append(OrderItemStub(name: "item1",
                                              originalPrice: 3_800,
                                              discounts: [discount1, discount2, discount3]))
        order.orderItems.append(OrderItemStub(name: "item2",
                                              originalPrice: 4_800,
                                              discounts: [discount1, discount3]))
        order.orderItems.append(OrderItemStub(name: "item3",
                                              originalPrice: 5_200,
                                              discounts: [discount3, discount4]))
        order.orderItems.append(OrderItemStub(name: "item4",
                                              originalPrice: 3_500,
                                              discounts: [discount4, discount5]))
        let billResult = OrderToBillProcessor.process(order: order)

        XCTAssertEqual(billResult?.items.count, 4)

        XCTAssertEqual(billResult?.items[0].containsStackableDiscounts, true)
        XCTAssertEqual(billResult?.items[1].containsStackableDiscounts, false)
        XCTAssertEqual(billResult?.items[2].containsStackableDiscounts, false)
        XCTAssertEqual(billResult?.items[3].containsStackableDiscounts, false)

        XCTAssertEqual(billResult?.items[0].discountedPrice, 1_050)
        XCTAssertEqual(billResult?.items[1].discountedPrice, 2_400)
        XCTAssertEqual(billResult?.items[2].discountedPrice, 2_600)
        XCTAssertEqual(billResult?.items[3].discountedPrice, 0)

        XCTAssertEqual(billResult?.establishmentDiscounts.count, 2)
        XCTAssertEqual(billResult?.establishmentDiscounts.first?.stackable, true)

        XCTAssertEqual(billResult?.grandTotal, 5_850)
    }

}
