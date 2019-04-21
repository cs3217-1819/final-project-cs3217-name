//
//  BillUnstackableEstablishmentDiscountTests.swift
//  NAMETests
//
//  Created by Derek Nam on 18/4/19.
//  Copyright © 2019 NAME. All rights reserved.
//

import XCTest
@testable import NAME

class BillUnstackableEstablishmentDiscountTests: XCTestCase {

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

    func testBill_grandTotal_WithEstablishmentNonStackableDiscount_MultiplierOnUndiscountedItems() {
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
                                priceModification: .multiplier(factor: 0.8),
                                stackable: false,
                                timeCondition: .dayRange(DateInterval()))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [discount],
                        establishmentSurcharges: [])

        XCTAssertNotEqual(bill.subtotal,
                          bill.grandTotal,
                          "Unstackable discount should be applied on all undiscounted items")
        XCTAssertEqual(bill.grandTotal, 2_700)
    }

    func testBill_grandTotal_WithEstablishmentNonStackableDiscount_MultiplierOnDiscountedItems() {
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
                                priceModification: .multiplier(factor: 0.8),
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

    func testBill_grandTotal_WithEstablishmentNonStackableDiscount_MultiplierOnNonstackableItems() {
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
                                priceModification: .multiplier(factor: 0.8),
                                stackable: false,
                                timeCondition: .dayRange(DateInterval()))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [discount],
                        establishmentSurcharges: [])

        XCTAssertEqual(bill.subtotal,
                       bill.grandTotal,
                       "Unstackable discount should not apply on unstackable items")
        XCTAssertEqual(bill.grandTotal, 5_000)
    }

    func testBill_grandTotal_WithEstablishmentSurcharges() {
        let item1 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 200,
                                 containsStackableDiscounts: false)

        let item2 = BillItemStub(originalPrice: 5_000,
                                 discountedPrice: 300,
                                 containsStackableDiscounts: true)

        let item3 = BillItemStub(originalPrice: 500,
                                 discountedPrice: 500,
                                 containsStackableDiscounts: nil)

        let surcharge1 = Surcharge(name: "GST", priceModification: .multiplier(factor: 0.07))
        let surcharge2 = Surcharge(name: "Service charge", priceModification: .multiplier(factor: 0.10))

        let bill = Bill(items: [item1, item2, item3],
                        establishmentDiscounts: [],
                        establishmentSurcharges: [surcharge1, surcharge2])

        XCTAssertNotEqual(bill.subtotal,
                          bill.grandTotal,
                          "Should differ since surcharges are present")
        XCTAssertEqual(bill.grandTotal, 1_170)
    }
}
