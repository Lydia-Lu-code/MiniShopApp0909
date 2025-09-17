
import UIKit

class CartItemCell: UITableViewCell {

    static let identifier = "CartItemCell"

    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0 // 自動換行
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private let minusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("-", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return btn
    }()

    private let plusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("+", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return btn
    }()

    var onQuantityChanged: ((Int) -> Void)?
    private var currentQuantity = 1
    
    private let itemImageView = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)

        productImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 商品圖片
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            // 標題
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: productImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor, constant: -12),

            // 價格
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            // 加減按鈕
            minusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            minusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 30),
            minusButton.heightAnchor.constraint(equalToConstant: 30),

            quantityLabel.trailingAnchor.constraint(equalTo: minusButton.leadingAnchor, constant: -6),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 30),

            plusButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -6),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
    }
    

    func configure(with item: CartItem) {
        productImageView.image = UIImage(named: item.title) // 可換成真實圖片屬性
        titleLabel.text = item.title
        priceLabel.text = "$\(item.price)"
        currentQuantity = item.quantity
        quantityLabel.text = "\(currentQuantity)"

    }

    @objc private func didTapMinus() {
        if currentQuantity > 1 {
            currentQuantity -= 1
            quantityLabel.text = "\(currentQuantity)"
            onQuantityChanged?(currentQuantity)
        }
    }

    @objc private func didTapPlus() {
        currentQuantity += 1
        quantityLabel.text = "\(currentQuantity)"
        onQuantityChanged?(currentQuantity)
    }
}
