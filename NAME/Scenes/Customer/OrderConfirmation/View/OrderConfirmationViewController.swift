import UIKit

protocol OrderConfirmationViewControllerInput: OrderConfirmationPresenterOutput {
    func loadDisplay(viewModel: OrderConfirmationViewModel)
}

protocol OrderConfirmationViewControllerOutput {
    func computeBill()
}

final class OrderConfirmationViewController: UITableViewController {

    static let cellReuseIdentifier = "orderConfirmationItemCellIdentifier"

    private class OrderConfirmationDataSource: NSObject, UITableViewDataSource {

        weak var delegate: OrderConfirmationItemViewCellDelegate?

        fileprivate let cellViewModel: OrderConfirmationViewModel

        init(order: OrderConfirmationViewModel) {
            self.cellViewModel = order
            super.init()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return cellViewModel.orderItems.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OrderConfirmationViewController.cellReuseIdentifier,
                for: indexPath)

            guard let itemCell = cell as? OrderConfirmationItemViewCell else {
                assertionFailure("Invalid table view cell.")
                return cell
            }

            let model = cellViewModel.orderItems[indexPath.row]

            itemCell.imageIdentifier = model.imageId
            itemCell.name = model.name
            itemCell.quantity = "\(model.quantity)"
            itemCell.originalPrice = model.originalPrice
            itemCell.discountedPrice = model.discountedPrice
            itemCell.isTakeAway = model.isTakeAway

            let additionalInformationView = OrderConfirmationAdditionalInfoView()

            model.options.forEach {
                let addOnView = OrderConfirmationItemOptionsAddonView()
                addOnView.imageIdentifier = $0.imageId
                addOnView.name = $0.name
                addOnView.option = $0.option
                addOnView.price = $0.price
                additionalInformationView.addOption(view: addOnView)
            }

            model.addons.forEach {
                let addOnView = OrderConfirmationItemOptionsAddonView()
                addOnView.imageIdentifier = $0.imageId
                addOnView.name = $0.name
                addOnView.price = $0.price
                additionalInformationView.addAddon(view: addOnView)
            }

            model.discounts.forEach {
                let discountView = OrderConfirmationItemDiscountView()
                discountView.name = $0.name
                discountView.effectDescription = $0.description
                additionalInformationView.addDiscount(view: discountView)
            }

            itemCell.additionalInformationView = additionalInformationView

            itemCell.selectionStyle = .none
            return itemCell
        }
    }

    override func tableView(_ tableView: UITableView,
                            viewForFooterInSection section: Int) -> UIView? {

        let orderTotalView = OrderConfirmationTotalView()

        guard let orderTotal = tableViewDataSource?.cellViewModel.orderTotal else {
            return nil
        }

        orderTotalView.subtotal = orderTotal.itemSubtotal
        orderTotalView.discounts = orderTotal.establishmentDiscounts
        orderTotalView.surcharges = orderTotal.establishmentSurcharges
        orderTotalView.total = orderTotal.grandTotal

        return orderTotalView
    }

    private var tableViewDataSource: OrderConfirmationDataSource? {
        didSet {
            tableView.dataSource = tableViewDataSource
            tableView.reloadData()
        }
    }

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

        tableView.register(OrderConfirmationItemViewCell.self,
                           forCellReuseIdentifier: OrderConfirmationViewController.cellReuseIdentifier)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        output?.computeBill()
    }
}

// MARK: - OrderConfirmationPresenterOutput

extension OrderConfirmationViewController: OrderConfirmationViewControllerInput {

    func loadDisplay(viewModel: OrderConfirmationViewModel) {
        tableViewDataSource = OrderConfirmationDataSource(order: viewModel)
    }
}

extension OrderViewController: OrderConfirmationItemViewCellDelegate {
    func didTapIncrease(forCell cell: UITableViewCell) {
        print("Tapped increase")
    }

    func didTapDecrease(forCell cell: UITableViewCell) {
        print("Tapped decrease")
    }
}

// MARK: - UIViewControllerRestoration

extension OrderConfirmationViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath path: [String], coder: NSCoder) -> UIViewController? {
        return self.init()
    }
}
