import SnapKit
import UIKit

class OrderConfirmationItemDiscountView: UIView {

    private let nameLabel = UILabel()
    private let effectDescriptionLabel = UILabel()

    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }

    var effectDescription: String? {
        get {
            return effectDescriptionLabel.text
        }
        set {
            effectDescriptionLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(nameLabel)
        addSubview(effectDescriptionLabel)
    }

    private func configureConstraints() {

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(OrderConfirmationDiscountConstants.nameLabelOffsetTop)
            make.left.equalToSuperview()
            make.bottom
                .equalTo(OrderConfirmationDiscountConstants.nameLabelBottom)
        }

        effectDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.top)
            make.left.equalTo(self.nameLabel.snp.right)
                .offset(OrderConfirmationDiscountConstants.descriptionLabelOffsetLeft)
        }
    }
}
