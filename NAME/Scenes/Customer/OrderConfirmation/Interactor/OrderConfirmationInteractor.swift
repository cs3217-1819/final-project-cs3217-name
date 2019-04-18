import UIKit

protocol OrderConfirmationInteractorInput: OrderConfirmationViewControllerOutput {
}

protocol OrderConfirmationInteractorOutput {
    func presentBill(_ bill: Bill)
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

    func computeBill() {
        output.presentBill(Bill())
    }

}
