struct BillItem {
    let source: OrderItem
    let discounts: [Discount]

    init(source: OrderItem, discounts: [Discount]) {
        self.source = source
        self.discounts = discounts
    }

    var discountedPrice: Int {

        let originalAmount = source.menuItem?.price ?? 0

        let totalAmountReduction = discounts.reduce(0) { total, discount in
            total + discount.toAbsolute(fromAmount: originalAmount)
        }

        return originalAmount - min(originalAmount, totalAmountReduction)
    }
}
