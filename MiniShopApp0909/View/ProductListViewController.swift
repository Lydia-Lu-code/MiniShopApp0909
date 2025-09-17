//
//  ProductListViewController.swift
//  MiniShopApp0909
//
//  Created by Lydia Lu on 2025/9/9.
//

import UIKit

class ProductListViewController: UIViewController {

    private let tableView = UITableView()
    private let viewModel = ProductListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mini Shop"
        view.backgroundColor = .white
        
        setupTableView()
        bindViewModel()
        viewModel.fetchProducts()  // 抓 API
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
    }

    private func bindViewModel() {
        // 當 ViewModel 取得資料時，更新 TableView
        viewModel.onProductsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ProductListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }

        let product = viewModel.item(at: indexPath.row)
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.item(at: indexPath.row)
        let cartVM = CartViewModel()
//        let cartVM = CartViewModel() // 可在 App 中共用單一 instance
        let detailVM = ProductDetailViewModel(product: product, cartViewModel: cartVM)
        let detailVC = ProductDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
