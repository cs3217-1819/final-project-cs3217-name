class OrderToBillProcessor {

    static func process(order: Order) -> Bill? {

        let billPossibilities = transformOrderToBill(order: order)

        return computeLowestBill(billPossibilities: billPossibilities)
    }

    static private func transformOrderToBill(order: Order) -> Bill {

        let orderItems = Array(order.orderItems)

        // TODO: make sure empty order is handled before this view controller
        assert(!orderItems.isEmpty)

        let billItems = orderItems.map { return self.transformOrderItemToBillItem(orderItem: $0) }

        // Process discounts at the establishment level
        guard let establishment = order.orderItems.first?.menuItem?.menu?.stall?.establishment else {
            fatalError("Unable to access establishment from order item")
        }
        let establishmentDiscounts = Array(establishment.discounts)
        let establishmentBillDiscounts = createBillDiscounts(price: 0, discounts: establishmentDiscounts)

        return Bill(items: billItems, establishmentDiscounts: establishmentBillDiscounts)
    }

    static private func transformOrderItemToBillItem(orderItem: OrderItem) -> BillItem {

        guard
            let price = orderItem.menuItem?.price,
            let discounts = orderItem.menuItem?.discounts else {

                fatalError("Failed to retrieve price and discounts of corresponding menu item")
        }

        let billDiscounts = createBillDiscounts(price: price, discounts: Array(discounts))

        return BillItem(source: orderItem, discounts: billDiscounts)
    }

    static private func createBillDiscounts(price: Int, discounts: [Discount]) -> [BillDiscount] {

        let billSavings = discounts.map { self.computeDiscountedAmount(originalPrice: price, discount: $0) }
        let createBillDiscount = { discount, saving in BillDiscount(source: discount, amountReduced: saving) }

        return zip(discounts, billSavings).map(createBillDiscount)
    }

    static private func computeDiscountedAmount(originalPrice: Int, discount: Discount) -> Int {
        switch discount.priceModification {
        case .absolute(amount: let decreaseAmount):
            return decreaseAmount
        case .multiplier(factor: let factor):
            // TODO: Add rounding
            return Int((Double(originalPrice) * factor))
        }
    }

    // Permutates through the different bill possibilities to calculate the
    // best deal for the user
    static private func computeLowestBill(billPossibilities: Bill) -> Bill {

        return Bill()
    }
}
