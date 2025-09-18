//
//  ProductDetailViewController.swift
//  MiniShopApp0909
//
//  Created by Lydia Lu on 2025/9/9.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {

    private let viewModel: ProductDetailViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let addToCartButton = UIButton(type: .system)

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "商品詳情"
        view.backgroundColor = .white
        setupUI()
        configureUI()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [imageView, titleLabel, priceLabel, descriptionLabel, addToCartButton].forEach {
            contentView.addSubview($0)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // 商品圖片
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }

        // 標題
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(20)
        }

        // 價格
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalTo(titleLabel)
        }

        // 商品描述，允許多行自動高度
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.left.right.equalTo(titleLabel)
        }

        // 加入購物車按鈕，貼在 contentView 底部，會隨內容自動推到最下
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(200)
        }
    }

    private func configureUI() {
        // 設定多行自動換行
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.lineBreakMode = .byWordWrapping

        imageView.kf.setImage(with: URL(string: viewModel.imageURL))
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.priceText
        descriptionLabel.text = viewModel.description

        addToCartButton.setTitle("加入購物車", for: .normal)
        addToCartButton.backgroundColor = .systemBlue
        addToCartButton.tintColor = .white
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
    }


    @objc private func addToCartTapped() {
        // ✅ 改成直接呼叫 CartViewModel.shared
        CartViewModel.shared.addItem(product: viewModel.toProduct())

        let alert = UIAlertController(title: "成功", message: "已加入購物車", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "查看購物車", style: .default, handler: { _ in
//            let cartVC = CartViewController() // 直接使用共用的 shared
            let cartVC = CartViewController(viewModel: CartViewModel.shared)

            self.navigationController?.pushViewController(cartVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "繼續購物", style: .cancel))
        present(alert, animated: true)
    }


}
