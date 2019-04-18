import UIKit

struct OrderConfirmationViewModel {
    struct OrderItemViewModel {
        let imageId: String
        let name: String
        let quantity: Int

        let originalPrice: String
        let discountedPrice: String

        let options: [OrderItemOptionViewModel]
        let addons: [OrderItemAddonViewModel]
        let discounts: [OrderItemDiscountViewModel]

        let isTakeAway: Bool
    }

    struct OrderItemOptionViewModel {
        let imageId: String
        let name: String
        let option: String
        let price: String
    }

    struct OrderItemAddonViewModel {
        let imageId: String
        let name: String
        let quantity: Int
        let price: String
    }

    struct OrderItemDiscountViewModel {
        let name: String
        let description: String
    }

    struct OrderTotal {
        let itemSubtotal: String
        let establishmentDiscounts: String
        let establishmentSurcharges: String
        let grandTotal: String
    }

    let orderItems: [OrderItemViewModel]
    let orderTotal: OrderTotal
}
