import UIKit

protocol OrderConfirmationInteractorInput: OrderConfirmationViewControllerOutput {
}

protocol OrderConfirmationInteractorOutput {
    func presentInit()
    func renderBill(bill: Bill)
}

final class OrderConfirmationInteractor {
    let output: OrderConfirmationInteractorOutput

    // MARK: - Initializers

    init(output: OrderConfirmationInteractorOutput) {
        self.output = output
    }
}

// MARK: - OrderConfirmationInteractorInput

extension OrderConfirmationInteractor: OrderConfirmationViewControllerOutput {

    // MARK: - Business logic

    func initializeScreen() {
        output.presentInit()
    }

    /// Calculate final payment breakdown
    func generateBill(order: Order) {

        guard let finalBill = OrderToBillProcessor.process(order: order) else {
            // TODO: Display error message to client
            return
        }
        output.renderBill(bill: finalBill)
    }

}
