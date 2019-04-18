import SnapKit
import UIKit

class OrderConfirmationTotalView: UIView {

    private let subtotalLabel = UILabel()
    private let discountsLabel = UILabel()
    private let surchargesLabel = UILabel()
    private let totalLabel = UILabel()

    let subtotalValueLabel = UILabel()
    let discountsValueLabel = UILabel()
    let surchargesValueLabel = UILabel()
    let totalValueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureConstraints()
    }

    var subtotal: String? {
        get {
            return subtotalValueLabel.text
        }
        set {
            subtotalValueLabel.text = newValue
        }
    }

    var discounts: String? {
        get {
            return discountsValueLabel.text
        }
        set {
            discountsValueLabel.text = newValue
        }
    }

    var surcharges: String? {
        get {
            return surchargesValueLabel.text
        }
        set {
            surchargesValueLabel.text = newValue
        }
    }

    var total: String? {
        get {
            return totalValueLabel.text
        }
        set {
            totalValueLabel.text = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = Colors.base

        addSubview(subtotalLabel)
        addSubview(discountsLabel)
        addSubview(surchargesLabel)
        addSubview(totalLabel)

        addSubview(subtotalValueLabel)
        addSubview(discountsValueLabel)
        addSubview(surchargesValueLabel)
        addSubview(totalValueLabel)

        subtotalLabel.text = OrderConfirmationTotalConstants.subtotalLabelTitle
        discountsLabel.text = OrderConfirmationTotalConstants.discountsLabelTitle
        surchargesLabel.text = OrderConfirmationTotalConstants.surchargesLabelTitle
        totalLabel.text = OrderConfirmationTotalConstants.totalLabelTitle

        subtotalLabel.font = subtotalLabel.font
            .withSize(OrderConfirmationTotalConstants.subtotalLabelFontSize)
        discountsLabel.font = subtotalLabel.font
            .withSize(OrderConfirmationTotalConstants.discountsSurchargesLabelFontSize)
        surchargesLabel.font = subtotalLabel.font
            .withSize(OrderConfirmationTotalConstants.discountsSurchargesLabelFontSize)
        totalLabel.font = UIFont
            .boldSystemFont(ofSize: OrderConfirmationTotalConstants.totalLabelFontSize)

        subtotalValueLabel.font = subtotalLabel.font
            .withSize(OrderConfirmationTotalConstants.subtotalLabelFontSize)
        discountsValueLabel.font = subtotalLabel.font
            .withSize(OrderConfirmationTotalConstants.discountsSurchargesLabelFontSize)
        surchargesValueLabel.font = subtotalLabel.font
            .withSize(OrderConfirmationTotalConstants.discountsSurchargesLabelFontSize)
        totalValueLabel.font = UIFont
            .boldSystemFont(ofSize: OrderConfirmationTotalConstants.totalLabelFontSize)

        subtotalLabel.textColor = OrderConfirmationTotalConstants.labelsColor
        discountsLabel.textColor = OrderConfirmationTotalConstants.labelsColor
        surchargesLabel.textColor = OrderConfirmationTotalConstants.labelsColor
        totalLabel.textColor = OrderConfirmationTotalConstants.labelsColor

        subtotalValueLabel.textColor = OrderConfirmationTotalConstants.labelsColor
        discountsValueLabel.textColor = OrderConfirmationTotalConstants.labelsColor
        surchargesValueLabel.textColor = OrderConfirmationTotalConstants.labelsColor
        totalValueLabel.textColor = OrderConfirmationTotalConstants.labelsColor
    }

    private func configureConstraints() {
        subtotalLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
                .offset(OrderConfirmationTotalConstants.totalsLabelsOffsetRight)
            make.top.equalToSuperview()
                .offset(OrderConfirmationTotalConstants.totalsLabelOffsetTop)
        }

        subtotalValueLabel.snp.makeConstraints { make in
            make.left.equalTo(self.subtotalLabel.snp.right)
                .offset(OrderConfirmationTotalConstants.totalsLabelPriceGap)
            make.top.equalTo(self.subtotalLabel.snp.top)
        }

        discountsLabel.snp.makeConstraints { make in
            make.right.equalTo(self.subtotalLabel.snp.right)
            make.top.equalTo(self.subtotalLabel.snp.bottom)
                .offset(OrderConfirmationTotalConstants.totalsLabelOffsetTop)
        }

        discountsValueLabel.snp.makeConstraints { make in
            make.left.equalTo(self.discountsLabel.snp.right)
                .offset(OrderConfirmationTotalConstants.totalsSubLabelPriceGap)
            make.top.equalTo(self.discountsLabel.snp.top)
        }

        surchargesLabel.snp.makeConstraints { make in
            make.right.equalTo(self.subtotalLabel.snp.right)
            make.top.equalTo(self.discountsLabel.snp.bottom)
                .offset(OrderConfirmationTotalConstants.totalsLabelOffsetTop)
        }

        surchargesValueLabel.snp.makeConstraints { make in
            make.left.equalTo(self.surchargesLabel.snp.right)
                .offset(OrderConfirmationTotalConstants.totalsSubLabelPriceGap)
            make.top.equalTo(self.surchargesLabel.snp.top)
        }

        totalLabel.snp.makeConstraints { make in
            make.right.equalTo(self.subtotalLabel.snp.right)
            make.top.equalTo(self.surchargesLabel.snp.bottom)
                .offset(OrderConfirmationTotalConstants.totalsLabelOffsetTop)
            make.bottom.equalTo(OrderConfirmationTotalConstants.grandTotalLabelBottom)
        }

        totalValueLabel.snp.makeConstraints { make in
            make.left.equalTo(self.totalLabel.snp.right)
                .offset(OrderConfirmationTotalConstants.totalsLabelPriceGap)
            make.top.equalTo(self.totalLabel.snp.top)
        }
    }
}
