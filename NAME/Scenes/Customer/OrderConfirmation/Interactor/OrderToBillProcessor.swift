class OrderToBillProcessor {

    static func process(order: Order) -> Bill? {

        let bill = Bill()
        bill.items = order.orderItems.compactMap { processOrderItem($0) }

        if let establishmentDiscounts = order.establishment?.discounts {

            bill.establishmentDiscounts = computeEstablishmentDiscounts(from: Array(establishmentDiscounts),
                                                                        subtotal: bill.subtotal)
        }

        return bill
    }

    static private func processOrderItem(_ orderItem: OrderItem) -> BillItem? {

        let possibleBillItems = generatePossibleBillItems(from: orderItem)

        return pickBestBillItem(from: possibleBillItems)
    }

    static private func generatePossibleBillItems(from orderItem: OrderItem) -> [BillItem] {

        guard let discounts = orderItem.menuItem?.discounts else {
            return [BillItem(source: orderItem, discounts: [])]
        }

        let stackableDiscounts = Array(discounts.filter { $0.stackable })
        let nonStackableDiscounts = Array(discounts.filter { !$0.stackable })

        var discountGroups: [[Discount]] = []
        discountGroups.append(stackableDiscounts)
        discountGroups.append(contentsOf: nonStackableDiscounts.map { [$0] })

        return discountGroups.map { BillItem(source: orderItem, discounts: $0) }
    }

    static private func pickBestBillItem(from billItems: [BillItem]) -> BillItem? {

        guard let firstBill = billItems.first else {
            return nil
        }

        return billItems.reduce(firstBill) { bestItem, item in
            if item.discountedPrice < bestItem.discountedPrice {
                return item
            }
            return bestItem
        }
    }

    static private func computeEstablishmentDiscounts(from discounts: [Discount], subtotal: Int) -> [Discount] {

        let stackableDiscounts = discounts.filter { $0.stackable }
        let totalDiscountStackable = stackableDiscounts.reduce(0) { total, discount in
            total + discount.toAbsolute(fromAmount: subtotal)
        }

        let nonStackableDiscounts = discounts.filter { !$0.stackable }
        guard let bestNSDiscount = maxDiscount(nonStackableDiscounts, from: subtotal) else {
            return stackableDiscounts
        }
        let bestNSDiscountAmount = bestNSDiscount.toAbsolute(fromAmount: subtotal)

        if totalDiscountStackable > bestNSDiscountAmount {
            return stackableDiscounts
        }

        return [bestNSDiscount]
    }

    static private func maxDiscount(_ discounts: [Discount], from amount: Int) -> Discount? {

        var maxAmount = 0
        var maxDiscount: Discount?

        for discount in discounts {

            let amountReduced = discount.toAbsolute(fromAmount: amount)

            if amountReduced > maxAmount {
                maxAmount = amountReduced
                maxDiscount = discount
            }
        }

        return maxDiscount
    }
}
