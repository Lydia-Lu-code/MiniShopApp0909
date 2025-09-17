//
//  ProductListViewModel.swift
//  MiniShopApp0909
//
//  Created by Lydia Lu on 2025/9/9.
//

import Foundation
import Alamofire

class ProductListViewModel {
    
    private var products: [Product] = []
    var onProductsUpdated: (() -> Void)?  // callback 通知 VC 更新 UI
    
    func fetchProducts() {
        let url = "https://fakestoreapi.com/products"
        AF.request(url).responseDecodable(of: [Product].self) { response in
            switch response.result {
            case .success(let items):
                self.products = items
                self.onProductsUpdated?()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func numberOfItems() -> Int {
        return products.count
    }
    
    func item(at index: Int) -> Product {
        return products[index]
    }
}
