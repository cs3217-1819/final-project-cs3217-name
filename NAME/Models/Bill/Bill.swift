class Bill: CustomStringConvertible {

    var items: [BillItemProtocol] = []
    var establishmentDiscounts: [Discount] = []
    var establishmentSurcharges: [Surcharge] = []

    init(items: [BillItemProtocol] = [],
         establishmentDiscounts: [Discount] = [],
         establishmentSurcharges: [Surcharge] = []) {
        self.items = items
        self.establishmentDiscounts = establishmentDiscounts
        self.establishmentSurcharges = establishmentSurcharges
    }

    var subtotal: Int {
        return subtotalStackables + subtotalNonStackables + subtotalNoDiscounts
    }

    var grandTotal: Int {
        // Check type of discount
        guard let firstDiscount = establishmentDiscounts.first else {
            return addSurchargesAndRound(subtotal)
        }
        if firstDiscount.stackable {
            return addSurchargesAndRound(grandTotalWithSDiscount)
        }
        return addSurchargesAndRound(grandTotalWithNSDiscount)
    }

    var description: String {
        var description = "Bill "
        description += "Subtotal: \(subtotal)\n"
        description += "Grand total: \(grandTotal)\n"
        description += "Items: \(items)\n"
        description += "Est. Discounts: \(establishmentDiscounts)\n"
        description += "Surcharges: \(establishmentSurcharges)\n================\n"
        return description
    }

    private var subtotalStackables: Int {
        let stackableItems = items.filter { $0.containsStackableDiscounts ?? false }

        return stackableItems.reduce(0) { subtotal, item in
            subtotal + item.discountedPrice
        }
    }

    private var subtotalNonStackables: Int {
        let nonStackableItems = items.filter { !($0.containsStackableDiscounts ?? true) }

        return nonStackableItems.reduce(0) { subtotal, item in
            subtotal + item.discountedPrice
        }
    }

    private var subtotalNoDiscounts: Int {
        let undiscountedItems = items.filter { $0.containsStackableDiscounts == nil }

        return undiscountedItems.reduce(0) { subtotal, item in
            subtotal + item.originalPrice
        }
    }

    private var grandTotalWithSDiscount: Int {
        let undiscountedOrStackableItems = items.filter { $0.containsStackableDiscounts ?? true }

        let sumAffected = undiscountedOrStackableItems.reduce(0) { total, item in
            total + item.discountedPrice
        }

        var totalPossibleDeduction = 0

        for discount in establishmentDiscounts {
            totalPossibleDeduction += discount.toAbsolute(fromAmount: sumAffected)
        }

        return max(self.subtotal - min(sumAffected, totalPossibleDeduction), 0)
    }

    private var grandTotalWithNSDiscount: Int {
        var runningSubtotal = self.subtotal

        let undiscountedItems = items.filter { $0.containsStackableDiscounts == nil }

        guard let nsDiscount = establishmentDiscounts.first else {
            return runningSubtotal
        }

        switch nsDiscount.priceModification {
        case .absolute(amount: let amt):
            var totalPriceAffected = 0

            for item in undiscountedItems {
                totalPriceAffected += item.originalPrice
            }
            runningSubtotal -= min(totalPriceAffected, amt)

        case .multiplier(factor: _):

            var amountReduced = 0

            for item in undiscountedItems {
                amountReduced += nsDiscount.toAbsolute(fromAmount: item.originalPrice)
            }

            runningSubtotal -= amountReduced
        }

        return max(runningSubtotal, 0)
    }

    private func addSurchargesAndRound(_ total: Int) -> Int {
        var runningTotal = total
        for surcharge in establishmentSurcharges {
            runningTotal += surcharge.toAbsolute(fromAmount: total)
        }
        return runningTotal
    }
}
