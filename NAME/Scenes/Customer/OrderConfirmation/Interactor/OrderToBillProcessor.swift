class OrderToBillProcessor {

    struct OrderItemComputation {
        let bestDiscounts: BillItem
        let bestStackableDiscounts: BillItem
    }

    static func process(order: OrderProtocol) -> Bill? {

        if order.orderItems.isEmpty {
            return nil
        }

        let orderItemComputations = Array(order.orderItems.compactMap { processOrderItem($0) })

        guard let bestBill = computeBestBill(itemComputations: orderItemComputations,
                                             discounts: order.establishmentDiscounts) else {
            return nil
        }

        // Apply surcharges to the best bill before returning the best bill
        guard let establishmentSurcharges = order.establishmentSurcharges else {
            return bestBill
        }

        bestBill.establishmentSurcharges = Array(establishmentSurcharges)
        return bestBill
    }

    static private func computeBestBill(itemComputations: [OrderItemComputation],
                                        discounts: [Discount]?) -> Bill? {

        // Return best discount(s) of each item if there are no discount constraints
        guard let establishmentDiscounts = discounts else {
            let bill = Bill()
            bill.items = itemComputations.map { $0.bestDiscounts }
            return bill
        }

        let noEstDiscountsBill = Bill(items: itemComputations.map { $0.bestDiscounts },
                                      establishmentDiscounts: [])

        let stackableDiscounts = Array(establishmentDiscounts.filter { $0.stackable })
        let bestSBill = optimizeWithStackableDiscounts(stackableDiscounts,
                                                        orderItemComputations: itemComputations)

        let nonStackableDiscounts = Array(establishmentDiscounts.filter { !$0.stackable })
        let bestNSBill = optimizeWithNonStackableDiscounts(nonStackableDiscounts,
                                                           orderItemComputations: itemComputations)

        return minBill(minBill(noEstDiscountsBill, bestSBill), bestNSBill)
    }

    static private func processOrderItem(_ orderItem: OrderItemProtocol) -> OrderItemComputation? {

        let stackableDiscounts = Array(orderItem.discounts.filter { $0.stackable })
        let stackableBillItem = BillItem(source: orderItem, discounts: stackableDiscounts)

        // Construct Bills for every non stackable discount
        let nonStackableDiscounts = Array(orderItem.discounts.filter { !$0.stackable })
        let nonStackableBillItems: [BillItem] = nonStackableDiscounts.map {
            return BillItem(source: orderItem, discounts: [$0])
        }

        let allBillItems: [BillItem] = [stackableBillItem] + nonStackableBillItems
        let lowestBillItem = allBillItems.reduce(stackableBillItem) { lowest, billItem in

            if billItem.discountedPrice <= lowest.discountedPrice {
                return billItem
            }
            return lowest
        }

        return OrderItemComputation(bestDiscounts: lowestBillItem,
                                    bestStackableDiscounts: stackableBillItem)
    }

    static private func optimizeWithStackableDiscounts(_ discounts: [Discount],
                                                       orderItemComputations: [OrderItemComputation]) -> Bill {
        let bill = Bill()
        bill.establishmentDiscounts = discounts
        bill.items = orderItemComputations.map { $0.bestStackableDiscounts }

        var bestSubtotal = bill.subtotal

        orderItemComputations.enumerated().forEach { idx, oic in

            guard
                let containsStackableDiscounts = oic.bestDiscounts.containsStackableDiscounts,
                !containsStackableDiscounts else {
                    return
            }

            // For best discounts that are not stackable, see if swapping will decrease the subtotal
            bill.items[idx] = orderItemComputations[idx].bestDiscounts

            if bill.subtotal < bestSubtotal {
                bestSubtotal = bill.subtotal
            } else {
                bill.items[idx] = orderItemComputations[idx].bestStackableDiscounts
            }
        }

        return bill
    }

    static private func optimizeWithNonStackableDiscounts(_ establishmentDiscounts: [Discount],
                                                          orderItemComputations: [OrderItemComputation]) -> Bill? {
        let bills = establishmentDiscounts.map {
            optimizeWithNonStackableDiscount($0,
                                             orderItemComputations: orderItemComputations)
        }

        return bills.reduce(bills.first, minBill)
    }

    static private func optimizeWithNonStackableDiscount(_ discount: Discount,
                                                         orderItemComputations: [OrderItemComputation]) -> Bill {
        let bill = Bill()
        bill.establishmentDiscounts = [discount]
        bill.items = orderItemComputations.compactMap {
            return BillItem(source: $0.bestDiscounts.source, discounts: [])
        }

        orderItemComputations.enumerated().forEach { idx, _ in

            let original = bill.items[idx]

            // See if substituting the item's bestDiscount will decrease the subtotal
            bill.items[idx] = orderItemComputations[idx].bestDiscounts
            let grandTotalWithItemBestDisc = bill.grandTotal

            bill.items[idx] = BillItem(source: original.source, discounts: [])
            let grandTotalWithNoItemDisc = bill.grandTotal

            if grandTotalWithItemBestDisc < grandTotalWithNoItemDisc {
                bill.items[idx] = orderItemComputations[idx].bestDiscounts
            }
        }
        return bill
    }

    static private func minBill(_ billA: Bill?, _ billB: Bill?) -> Bill? {
        guard let billAGrandTotal = billA?.grandTotal else {
            return billB
        }

        guard let billBGrandTotal = billB?.grandTotal else {
            return billA
        }

        if billAGrandTotal <= billBGrandTotal {
            return billA
        }
        return billB
    }
}
