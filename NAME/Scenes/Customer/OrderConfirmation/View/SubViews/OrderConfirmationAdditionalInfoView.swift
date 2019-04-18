import SnapKit
import UIKit

class OrderConfirmationAdditionalInfoView: UIView {

    private let addonsLabel: UILabel = {
        let label = UILabel()
        label.text = OrderConfirmationItemConstants.addonsLabelTitle
        label.font = UIFont
            .boldSystemFont(ofSize: OrderConfirmationItemConstants.additionalsLabelFontSize)
        label.isHidden = true
        return label
    }()

    private let optionsLabel: UILabel = {
        let label = UILabel()
        label.text = OrderConfirmationItemConstants.optionsLabelTitle
        label.font = UIFont
            .boldSystemFont(ofSize: OrderConfirmationItemConstants.additionalsLabelFontSize)
        label.isHidden = true
        return label
    }()

    private let discountsLabel: UILabel = {
        let label = UILabel()
        label.text = OrderConfirmationItemConstants.discountsLabelTitle
        label.font = UIFont
            .boldSystemFont(ofSize: OrderConfirmationItemConstants.additionalsLabelFontSize)
        label.isHidden = true
        return label
    }()

    private let addonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private let optionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private let discountsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addAddon(view: UIView) {
        addonsLabel.isHidden = false
        addonsStack.addArrangedSubview(view)
    }

    func addOption(view: UIView) {
        optionsLabel.isHidden = false
        optionsStack.addArrangedSubview(view)
    }

    func addDiscount(view: UIView) {
        discountsLabel.isHidden = false
        discountsStack.addArrangedSubview(view)
    }

    private func setupView() {
        addSubview(addonsLabel)
        addSubview(optionsLabel)
        addSubview(discountsLabel)
        addSubview(addonsStack)
        addSubview(optionsStack)
        addSubview(discountsStack)
    }

    private func configureConstraints() {
        optionsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(OrderConfirmationItemConstants.nameOptionsLabelOffsetHeight)
            make.left.equalToSuperview()
        }

        optionsStack.snp.makeConstraints { make in
            make.top.equalTo(self.optionsLabel.snp.bottom)
                .offset(OrderConfirmationItemConstants.additionalsOffsetTop)
            make.left.equalTo(self.optionsLabel.snp.left)
        }

        addonsLabel.snp.makeConstraints { make in
            make.top.equalTo(self.optionsStack.snp.bottom)
                .offset(OrderConfirmationItemConstants.additionalsLabelsOffsetTop)
            make.left.equalTo(self.optionsLabel.snp.left)
        }

        addonsStack.snp.makeConstraints { make in
            make.top.equalTo(self.addonsLabel.snp.bottom)
                .offset(OrderConfirmationItemConstants.additionalsOffsetTop)
            make.left.equalTo(self.optionsLabel.snp.left)
        }

        discountsLabel.snp.makeConstraints { make in
            make.top.equalTo(self.addonsStack.snp.bottom)
                .offset(OrderConfirmationItemConstants.additionalsLabelsOffsetTop)
            make.left.equalTo(self.optionsLabel.snp.left)
        }

        discountsStack.snp.makeConstraints { make in
            make.top.equalTo(self.discountsLabel.snp.bottom)
                .offset(OrderConfirmationItemConstants.additionalsOffsetTop)
            make.left.equalTo(self.optionsLabel.snp.left)
            make.bottom.equalTo(OrderConfirmationItemConstants.discountsStackBottom)
        }
    }
}
