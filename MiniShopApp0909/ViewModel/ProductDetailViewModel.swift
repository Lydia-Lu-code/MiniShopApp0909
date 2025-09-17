//
//  ProductDetailViewModel.swift
//  MiniShopApp0909
//
//  Created by Lydia Lu on 2025/9/9.
//

import Foundation

class ProductDetailViewModel {
    private let product: Product
    private let cartViewModel: CartViewModel

    init(product: Product, cartViewModel: CartViewModel) {
        self.product = product
        self.cartViewModel = cartViewModel
    }

    var title: String { product.title }
    var price: Double { product.price }
    var priceText: String { String(format: "$%.2f", product.price) }
    var description: String { product.description }
    var imageURL: String { product.image }

    func toProduct() -> Product {
        return product
    }

    
    func addToCart() {
        cartViewModel.addItem(product: product)
    }
}
