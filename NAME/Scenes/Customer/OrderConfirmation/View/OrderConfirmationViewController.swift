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

        configure(configurator: configurator)
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        configure()
    }

    // MARK: - Configurator

    private func configure(configurator: OrderConfirmationConfigurator = OrderConfirmationConfigurator.shared) {
        configurator.configure(viewController: self)
        restorationIdentifier = String(describing: type(of: self))
        restorationClass = type(of: self)
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

// MARK: - UIViewControllerRestoration

extension OrderConfirmationViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
