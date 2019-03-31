/// Represents the breakdown of the final price to be received
/// from the customer on a per item basis, based on order
/// selections made, with discounts and surcharges applied.

class Bill {
    var items: [BillItem] = []
    var establishmentDiscounts: [BillDiscount] = []
    var establishmentSurcharges: [BillSurcharge] = []

    init(items: [BillItem] = [],
         establishmentDiscounts: [BillDiscount] = [],
         establishmentSurcharges: [BillSurcharge] = []) {
        self.items = items
        self.establishmentDiscounts = establishmentDiscounts
        self.establishmentSurcharges = establishmentSurcharges
    }
}
