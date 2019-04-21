//
//  BillTests.swift
//  NAMETests
//
//  Created by Derek Nam on 18/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import XCTest
@testable import NAME

class BillTests: XCTestCase {

    struct BillItemStub: BillItemProtocol {
        var source: OrderItemProtocol?
        var originalPrice: Int
        var discountedPrice: Int
        var containsStackableDiscounts: Bool?
        init(originalPrice: Int, discountedPrice: Int, containsStackableDiscounts: Bool?) {
            self.originalPrice = originalPrice
            self.discountedPrice = discountedPrice
            self.containsStackableDiscounts = containsStackableDiscounts
        }
    }

    func testBill_subtotal_computedCorrectly() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 200,
                                 containsStackableDiscounts: false)

        let item2 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 300,
                                 containsStackableDiscounts: true)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 500,
                                 containsStackableDiscounts: nil)

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [],
                        establishmentSurcharges: [])

        XCTAssertEqual(bill.subtotal, 1_000)
    }

    func testBill_grandTotal_NoEstablishmentDiscountsSurcharges() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 200,
                                 containsStackableDiscounts: false)

        let item2 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 300,
                                 containsStackableDiscounts: true)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 500,
                                 containsStackableDiscounts: nil)

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [],
                        establishmentSurcharges: [])

        XCTAssertEqual(bill.subtotal,
                       bill.grandTotal,
                       "Should not differ if no establishment modifiers are present")
    }

    func testBill_grandTotal_WithEstablishmentStackableDiscounts() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 200,
                                 containsStackableDiscounts: false)

        let item2 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 300,
                                 containsStackableDiscounts: true)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 500,
                                 containsStackableDiscounts: nil)

        let discount1 = Discount(name: "Discount",
                                 priceModification: .absolute(amount: 500),
                                 stackable: true,
                                 timeCondition: .dayRange(DateInterval()))

        let discount2 = Discount(name: "Discount",
                                 priceModification: .multiplier(factor: 0.1),
                                 stackable: true,
                                 timeCondition: .dayRange(DateInterval()))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [discount1, discount2],
                        establishmentSurcharges: [])

        XCTAssertNotEqual(bill.subtotal,
                          bill.grandTotal,
                          "Stackable discount should only be applied on stackable or undiscounted items")
        XCTAssertEqual(bill.grandTotal, 400)
    }

    func testBill_grandTotal_WithEstablishmentStackableDiscounts_BoundedByStackableOrUndiscounted() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 200,
                                 containsStackableDiscounts: false)

        let item2 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 300,
                                 containsStackableDiscounts: true)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 500,
                                 containsStackableDiscounts: nil)

        let discount1 = Discount(name: "Discount",
                                 priceModification: .absolute(amount: 1_234),
                                 stackable: true,
                                 timeCondition: .dayRange(DateInterval()))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [discount1],
                        establishmentSurcharges: [])

        XCTAssertNotEqual(bill.subtotal,
                          bill.grandTotal,
                          "Stackable discount should only be applied on stackable or undiscounted items")
        XCTAssertEqual(bill.grandTotal, 200)
    }

    func testBill_grandTotal_WithEstablishmentNonStackableDiscount_AbsoluteOnUndiscountedItems() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 5_000,
                                 containsStackableDiscounts: nil)

        let item2 = BillItemStub(originalPrice: 8_000,
                                 discountedPrice: 8_000,
                                 containsStackableDiscounts: nil)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 500,
                                 containsStackableDiscounts: nil)

        let discount = Discount(name: "Discount",
                                 priceModification: .absolute(amount: 1_234),
                                 stackable: false,
                                 timeCondition: .dayRange(DateInterval()))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [discount],
                        establishmentSurcharges: [])

        XCTAssertNotEqual(bill.subtotal,
                          bill.grandTotal,
                          "Unstackable discount should be applied on all undiscounted items")
        XCTAssertEqual(bill.grandTotal, 12_266)
    }

    func testBill_grandTotal_WithEstablishmentNonStackableDiscount_AbsoluteOnDiscountedItems() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 4_000,
                                 containsStackableDiscounts: true)

        let item2 = BillItemStub(originalPrice: 8_000,
                                 discountedPrice: 700,
                                 containsStackableDiscounts: true)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 300,
                                 containsStackableDiscounts: false)

        let discount = Discount(name: "Discount",
                                priceModification: .absolute(amount: 1_234),
                                stackable: false,
                                timeCondition: .dayRange(DateInterval()))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [discount],
                        establishmentSurcharges: [])

        XCTAssertEqual(bill.subtotal,
                       bill.grandTotal,
                       "Unstackable discount should not apply on discounted items")
        XCTAssertEqual(bill.grandTotal, 5_000)
    }

    func testBill_grandTotal_WithEstablishmentNonStackableDiscount_AbsoluteOnNonstackableItems() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 4_000,
                                 containsStackableDiscounts: false)

        let item2 = BillItemStub(originalPrice: 8_000,
                                 discountedPrice: 700,
                                 containsStackableDiscounts: false)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 300,
                                 containsStackableDiscounts: false)

        let discount = Discount(name: "Discount",
                                priceModification: .absolute(amount: 1_234),
                                stackable: false,
                                timeCondition: .dayRange(DateInterval()))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [discount],
                        establishmentSurcharges: [])

        XCTAssertEqual(bill.subtotal,
                       bill.grandTotal,
                       "Unstackable discount should not apply on non stackable items")
        XCTAssertEqual(bill.grandTotal, 5_000)
    }
}
