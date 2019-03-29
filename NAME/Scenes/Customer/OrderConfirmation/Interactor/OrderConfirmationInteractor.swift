import UIKit

protocol OrderConfirmationInteractorInput: OrderConfirmationViewControllerOutput {
}

protocol OrderConfirmationInteractorOutput {
    func presentInit()
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

    func doSomething() {
        // Do something
    }

}
