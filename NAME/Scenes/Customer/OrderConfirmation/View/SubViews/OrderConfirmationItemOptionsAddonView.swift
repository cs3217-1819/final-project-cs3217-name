import SnapKit
import UIKit

class OrderConfirmationItemOptionsAddonView: UIView {

    private let image = UIImageView()
    private var imageName: String?

    private let nameLabel = UILabel()
    private let optionLabel = UILabel()
    private let priceLabel = UILabel()

    var imageIdentifier: String? {
        get {
            return imageName
        }
        set {
            guard let imageName = newValue else {
                return
            }

            image.image = UIImage(named: imageName)
        }
    }

    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }

    var option: String? {
        get {
            return optionLabel.text
        }
        set {
            optionLabel.text = newValue
        }
    }

    var price: String? {
        get {
            return priceLabel.text
        }
        set {
            priceLabel.text = newValue
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
        addSubview(image)
        addSubview(nameLabel)
        addSubview(optionLabel)
        addSubview(priceLabel)
    }

    private func configureConstraints() {

        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height
                .equalTo(OrderConfirmationOptionsAddonConstants.imageLength)
            make.width
                .equalTo(OrderConfirmationOptionsAddonConstants.imageLength)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(OrderConfirmationOptionsAddonConstants.nameLabelOffsetTop)
            make.left.equalTo(self.image.snp.right)
                .offset(OrderConfirmationOptionsAddonConstants.nameLabelOffsetLeft)
            make.bottom
                .equalTo(OrderConfirmationOptionsAddonConstants.nameLabelBottom)
        }

        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.top)
            make.left.equalTo(self.nameLabel.snp.right)
                .offset(OrderConfirmationOptionsAddonConstants.optionPriceLabelOffsetLeft)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.top)
            make.left.equalTo(self.optionLabel.snp.right)
                .offset(OrderConfirmationOptionsAddonConstants.optionPriceLabelOffsetLeft)
        }
    }
}
