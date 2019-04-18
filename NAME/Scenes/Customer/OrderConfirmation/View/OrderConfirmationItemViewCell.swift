import SnapKit

protocol OrderConfirmationItemViewCellDelegate: class {
    func didTapIncrease(forCell cell: UITableViewCell)
    func didTapDecrease(forCell cell: UITableViewCell)
}

final class OrderConfirmationItemViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: type(of: self))

    private let itemImage = UIImageView()
    private var imageName: String?

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: OrderConfirmationItemConstants.nameLabelFontSize)
        return label
    }()

    var additionalInformationView: OrderConfirmationAdditionalInfoView? {
        didSet {
            guard let view = additionalInformationView else {
                return
            }
            addSubview(view)

            additionalInformationView?.snp.makeConstraints { make in
                make.top.equalTo(self.nameLabel).offset(50)
                make.left.equalTo(self.nameLabel.snp.left)
                make.bottom.equalTo(-20)
            }
        }
    }

    private let originalPriceLabel = UILabel()
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: OrderConfirmationItemConstants.discountedPriceFontSize)
        return label
    }()

    private let removeItemButton: UIButton = {
        let button = UIButton()
        button.setTitle(OrderConfirmationItemConstants.removeItemButtonTitle,
                        for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()

    private let diningOptionControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: OrderConfirmationItemConstants.diningOptionControlHeretitle,
                              at: 0, animated: true)
        control.insertSegment(withTitle: OrderConfirmationItemConstants.diningOptionControlTakeAwaytitle,
                              at: 1, animated: true)
        return control
    }()

    var imageIdentifier: String? {
        get {
            return imageName
        }
        set {
            guard let imageName = newValue else {
                return
            }
            itemImage.image = UIImage(named: imageName)
        }
    }

    public var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }

    var quantity: String? {
        get {
            // TODO: obtain value from view
            return nil
        }
        set {
            // TODO: assign value to view
        }
    }

    var originalPrice: String? {
        get {
            return originalPriceLabel.attributedText?.string
        }
        set {

            guard let originalPriceStr = newValue else {
                return
            }
            let attrs: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                                        .strikethroughColor: UIColor.black]
            let originalPriceStrikethrough = NSMutableAttributedString(string: originalPriceStr,
                                                                       attributes: attrs)

            originalPriceLabel.attributedText = originalPriceStrikethrough
        }
    }

    var discountedPrice: String? {
        get {
            return discountedPriceLabel.text
        }
        set {
            discountedPriceLabel.text = newValue
        }
    }

    var isTakeAway: Bool? {
        get {
            return diningOptionControl.selectedSegmentIndex == 1
        }
        set {
            guard let takeAway = newValue else {
                return
            }
            diningOptionControl.selectedSegmentIndex = takeAway ? 1 : 0
        }
    }

    weak var delegate: OrderConfirmationItemViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(itemImage)
        addSubview(nameLabel)
        addSubview(originalPriceLabel)
        addSubview(discountedPriceLabel)
        addSubview(removeItemButton)
        addSubview(originalPriceLabel)
        addSubview(discountedPriceLabel)
        addSubview(diningOptionControl)
    }

    private func configureConstraints() {
        itemImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(OrderConfirmationItemConstants.imageOffsetTop)
            make.left.equalToSuperview().offset(OrderConfirmationItemConstants.imageOffsetLeft)
            make.height.equalTo(OrderConfirmationItemConstants.imageLength)
            make.width.equalTo(OrderConfirmationItemConstants.imageLength)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(OrderConfirmationItemConstants.nameLabelOffsetTop)
            make.left.equalTo(self.itemImage.snp.right)
                .offset(OrderConfirmationItemConstants.nameLabelOffsetLeft)
        }

        discountedPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.top)
            make.right.equalToSuperview()
                .offset(OrderConfirmationItemConstants.priceLabelsOffsetRight)
        }

        originalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.discountedPriceLabel.snp.bottom)
                .offset(OrderConfirmationItemConstants.priceLabelsGapHeight)
            make.right.equalToSuperview()
                .offset(OrderConfirmationItemConstants.priceLabelsOffsetRight)
        }

        diningOptionControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
                .offset(OrderConfirmationItemConstants.diningOptionControlOffsetBottom)
            make.right.equalToSuperview()
                .offset(OrderConfirmationItemConstants.diningOptionControlOffsetRight)
        }
    }

    func didTapIncrease() {
        delegate?.didTapIncrease(forCell: self)
    }

    func didTapDecrease() {
        delegate?.didTapDecrease(forCell: self)
    }
}
