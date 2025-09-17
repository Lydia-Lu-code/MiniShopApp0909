

import UIKit
import Lottie

class CartViewController: UIViewController {
    fileprivate var viewModel = CartViewModel.shared
    private let tableView = UITableView()
    private let totalLabel = UILabel()
    private let checkoutButton = UIButton(type: .system)

        init(viewModel: CartViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "購物車"
        view.backgroundColor = .white
        setupUI()
        bindViewModel()
        updateTotalLabel() // 初始總價顯示

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(totalLabel)
        view.addSubview(checkoutButton)

        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(checkoutButton.snp.top).offset(-12)
        }

        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(checkoutButton.snp.top).offset(-4)
        }

        checkoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }

        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        tableView.dataSource = self

        checkoutButton.setTitle("結帳", for: .normal)
        checkoutButton.backgroundColor = .systemGreen
        checkoutButton.tintColor = .white
        checkoutButton.layer.cornerRadius = 8
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)

        totalLabel.font = .boldSystemFont(ofSize: 20)
        totalLabel.textColor = .black
    }

    private func bindViewModel() {
        viewModel.onCartUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateTotalLabel()
            }
        }
        viewModel.onCartUpdated?()
    }

    // MARK: - 更新總價
    func updateTotalLabel() {
        totalLabel.text = "總計：$\(viewModel.totalAmount())"
    }

    // MARK: - 結帳流程
    @objc private func checkoutTapped() {
        guard !viewModel.items.isEmpty else {
            let alert = UIAlertController(title: "購物車是空的", message: "請先加入商品再結帳", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .default))
            present(alert, animated: true)
            return
        }

        // ✅ Lottie 動畫
        let animationView = LottieAnimationView(name: "SuccessCheck")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        animationView.loopMode = .playOnce
        view.addSubview(animationView)

        animationView.play { [weak self] _ in
            guard let self = self else { return }
            animationView.removeFromSuperview()

            // 清空購物車
            self.viewModel.items.removeAll()
            self.viewModel.onCartUpdated?()

            // 彈出成功提示
            let alert = UIAlertController(title: "付款成功", message: "感謝您的購買！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartItemCell.identifier,
            for: indexPath
        ) as? CartItemCell else {
            return UITableViewCell()
        }

        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)

        // 綁定加減按鈕事件
        cell.onQuantityChanged = { [weak self] newQuantity in
            guard let self = self else { return }
            self.viewModel.updateQuantity(at: indexPath.row, quantity: newQuantity)
            self.updateTotalLabel()
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }

        return cell
    }
}
