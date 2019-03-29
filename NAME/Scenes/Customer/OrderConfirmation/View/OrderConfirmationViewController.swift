import UIKit

protocol OrderConfirmationViewControllerInput: OrderConfirmationPresenterOutput {

}

protocol OrderConfirmationViewControllerOutput {

    func doSomething()
}

final class OrderConfirmationViewController: UISplitViewController {

    var output: OrderConfirmationViewControllerOutput?
    var router: OrderConfirmationRouterProtocol?

    // MARK: - Initializers

    init(configurator: OrderConfirmationConfigurator = OrderConfirmationConfigurator.shared) {

        super.init(nibName: nil, bundle: nil)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: OrderConfirmationConfigurator = OrderConfirmationConfigurator.shared) {
        configurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - OrderConfirmationPresenterOutput

extension OrderConfirmationViewController: OrderConfirmationViewControllerInput {

    func reloadDisplay(viewModel: OrderConfirmationViewModel) {
        // Reload display
    }
}
