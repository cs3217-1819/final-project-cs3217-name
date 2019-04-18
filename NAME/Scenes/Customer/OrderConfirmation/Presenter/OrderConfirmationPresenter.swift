import UIKit

protocol OrderConfirmationPresenterInput: OrderConfirmationInteractorOutput {
}

protocol OrderConfirmationPresenterOutput: class {
    func loadDisplay(viewModel: OrderConfirmationViewModel)
}

final class OrderConfirmationPresenter {

    private(set) unowned var output: OrderConfirmationPresenterOutput

    // MARK: - Initializers

    init(output: OrderConfirmationPresenterOutput) {
        self.output = output
    }
}

// MARK: - OrderConfirmationPresenterInput

extension OrderConfirmationPresenter: OrderConfirmationPresenterInput {

    typealias ViewModel = OrderConfirmationViewModel
    typealias ItemView = OrderConfirmationViewModel.OrderItemViewModel
    typealias ItemAddonView = OrderConfirmationViewModel.OrderItemAddonViewModel
    typealias ItemOptionView = OrderConfirmationViewModel.OrderItemOptionViewModel
    typealias ItemDiscountView = OrderConfirmationViewModel.OrderItemDiscountViewModel
    typealias OrderTotalView = OrderConfirmationViewModel.OrderTotal

    // MARK: - Presentation logic

    func presentBill(_ bill: Bill) {

        // TODO: Remove placeholders, add bill to view model here

        let IMAGEPLACEHOLDER = "placeholder"
        let PRICEPLACEHOLDER = "$12.34"

        let option1 = ItemOptionView(imageId: IMAGEPLACEHOLDER,
                                     name: "Option",
                                     option: "✓",
                                     price: PRICEPLACEHOLDER)

        let discount1 = ItemDiscountView(name: "Discount",
                                         description: "-20%")

        let addon1 = ItemAddonView(imageId: IMAGEPLACEHOLDER,
                                    name: "Addon",
                                    quantity: 1,
                                    price: PRICEPLACEHOLDER)

        let aaa = ItemView(imageId: IMAGEPLACEHOLDER,
                           name: "Chimken",
                           quantity: 1,
                           originalPrice: PRICEPLACEHOLDER,
                           discountedPrice: PRICEPLACEHOLDER,
                           options: [option1],
                           addons: [addon1],
                           discounts: [discount1],
                           isTakeAway: false)

        let bbb = ItemView(imageId: IMAGEPLACEHOLDER,
                           name: "Fishball",
                           quantity: 1,
                           originalPrice: PRICEPLACEHOLDER,
                           discountedPrice: PRICEPLACEHOLDER,
                           options: [],
                           addons: [],
                           discounts: [discount1],
                           isTakeAway: true)

        let orderItems: [ItemView] = [aaa, bbb, aaa, bbb, aaa, bbb]
        let orderTotal = OrderTotalView(itemSubtotal: PRICEPLACEHOLDER,
                                        establishmentDiscounts: PRICEPLACEHOLDER,
                                        establishmentSurcharges: PRICEPLACEHOLDER,
                                        grandTotal: PRICEPLACEHOLDER)

        let viewModel = ViewModel(orderItems: orderItems,
                                  orderTotal: orderTotal)
        output.loadDisplay(viewModel: viewModel)
    }

}
