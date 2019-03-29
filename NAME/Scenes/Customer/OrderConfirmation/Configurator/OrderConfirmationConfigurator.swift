import UIKit

final class OrderConfirmationConfigurator {

    // MARK: - Singleton

    static let shared: OrderConfirmationConfigurator = OrderConfirmationConfigurator()

    // MARK: - Configuration

    func configure(viewController: OrderConfirmationViewController) {

        let router = OrderConfirmationRouter(viewController: viewController)
        let presenter = OrderConfirmationPresenter(output: viewController)
        let interactor = OrderConfirmationInteractor(output: presenter)

        viewController.output = interactor
        viewController.router = router

    }
}
