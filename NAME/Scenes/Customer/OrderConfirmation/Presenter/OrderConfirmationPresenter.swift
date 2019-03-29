import UIKit

protocol OrderConfirmationPresenterInput: OrderConfirmationInteractorOutput {
}

protocol OrderConfirmationPresenterOutput: class {
    func reloadDisplay(viewModel: OrderConfirmationViewModel)
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

    // MARK: - Presentation logic

    func presentInit() {
        let viewModel = OrderConfirmationViewModel()
        output.reloadDisplay(viewModel: viewModel)
    }
}
