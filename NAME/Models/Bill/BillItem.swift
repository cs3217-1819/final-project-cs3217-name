protocol BillItemProtocol {
    var originalPrice: Int { get }
    var discountedPrice: Int { get }
    var containsStackableDiscounts: Bool? { get }
}

struct BillItem: BillItemProtocol {
    let source: OrderItemProtocol?
    let discounts: [Discount]

    init(source: OrderItemProtocol?, discounts: [Discount]) {
        self.source = source
        self.discounts = discounts
        checkRep()
    }

    var originalPrice: Int {
        return source?.price ?? 0
    }

    var discountedPrice: Int {

        guard let originalAmount = source?.price else {
            return 0
        }

        let totalAmountReduction = discounts.reduce(0) { total, discount in
            total + discount.toAbsolute(fromAmount: originalAmount)
        }

        return originalAmount - min(originalAmount, totalAmountReduction)
    }

    var containsStackableDiscounts: Bool? {
        return self.discounts.first?.stackable
    }

    private func checkRep() {

        assert(originalPrice >= discountedPrice)
        assert(discountedPrice >= 0)

        guard let firstDiscount = discounts.first else {
            return
        }

        if firstDiscount.stackable {
            assert(discounts.filter { $0.stackable }.count == discounts.count,
                   "Should not contain a mix of stackable and non stackable discounts")
        } else {
            assert(discounts.count == 1,
                   "Should not contain more than a single non stackable discount")
        }
    }
}
