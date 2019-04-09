/// Represents the breakdown of the final price to be received
/// from the customer on a per item basis, based on order
/// selections made, with discounts and surcharges applied.

class Bill {
    var items: [BillItem] = []
    var establishmentDiscounts: [Discount] = []
    var establishmentSurcharges: [Surcharge] = []

    init(items: [BillItem] = [],
         establishmentDiscounts: [Discount] = [],
         establishmentSurcharges: [Surcharge] = []) {
        self.items = items
        self.establishmentDiscounts = establishmentDiscounts
        self.establishmentSurcharges = establishmentSurcharges
    }

    var subtotal: Int {
        return items.reduce(0) { subtotal, item in subtotal + item.discountedPrice }
    }

    var grandTotal: Int {

        let subtotal = self.subtotal

        var subtotalAfterDiscount = subtotal
        for discount in establishmentDiscounts {
            subtotalAfterDiscount -= discount.toAbsolute(fromAmount: subtotal)
        }
        subtotalAfterDiscount = max(subtotalAfterDiscount, 0)

        var total = subtotalAfterDiscount

        for surcharge in establishmentSurcharges {
            total += surcharge.toAbsolute(fromAmount: subtotalAfterDiscount)
        }

        return max(total, 0)
    }
}
