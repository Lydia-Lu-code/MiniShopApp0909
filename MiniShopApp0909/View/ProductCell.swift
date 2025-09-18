//
//  ProductCell.swift
//  MiniShopApp0909
//
//  Created by Lydia Lu on 2025/9/9.
//
//
import UIKit
import SnapKit

class ProductCell: UITableViewCell {
    static let identifier = "ProductCell"
    
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        productImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(productImageView.snp.right).offset(12)
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
    }
    
    func configure(with product: Product) {
        titleLabel.text = product.title
        priceLabel.text = "$\(product.price)"
        productImageView.kf.setImage(with: URL(string: product.image))
    }
}

