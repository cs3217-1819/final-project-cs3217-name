import UIKit

protocol OrderConfirmationRouterProtocol {

    var viewController: OrderConfirmationViewController? { get }

    func navigateToCustomerMenu()
}

final class OrderConfirmationRouter {

    weak var viewController: OrderConfirmationViewController?

    // MARK: - Initializers

    init(viewController: OrderConfirmationViewController?) {
        self.viewController = viewController
    }
}

// MARK: - OrderConfirmationRouterProtocol

extension OrderConfirmationRouter: OrderConfirmationRouterProtocol {
    // MARK: - Navigation

    func navigateToCustomerMenu() {
        let customerRootVC = CustomerRootViewController()
        customerRootVC.modalTransitionStyle = .crossDissolve
        viewController?.present(customerRootVC, animated: true)
    }
}
