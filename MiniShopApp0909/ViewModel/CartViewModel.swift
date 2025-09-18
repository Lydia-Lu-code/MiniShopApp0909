//
//  CartViewModel.swift
//  MiniShopApp0909
//
//  Created by Lydia Lu on 2025/9/9.
//

import Foundation

class CartViewModel {
    
    static let shared = CartViewModel() // 單例
    init() {} // 確保只能透過 shared 使用
    
    var items: [CartItem] = []
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }

    var onCartUpdated: (() -> Void)?
    

    
    func addItem(product: Product) {
        // ✅ 判斷是否已存在相同商品（用 title + price）
        if let index = items.firstIndex(where: { $0.title == product.title && $0.price == product.price }) {
            items[index].quantity += 1  // 已存在 → 累加數量
        } else {
            let newItem = CartItem(title: product.title, price: product.price, quantity: 1, image: product.image)
            items.append(newItem)       // 新商品 → 新增一列
        }

        // 更新購物車 UI
        onCartUpdated?()
    }
    
    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
        onCartUpdated?()
    }
    
    
    
    
    func updateQuantity(at index: Int, quantity: Int) {
        guard index < items.count else { return }
        items[index].quantity = quantity
        onCartUpdated?()
    }

    func totalAmount() -> Int {
        let total = items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        return Int(ceil(total)) // 無條件進位，轉成 Int
    }

}

// 如果在 struct 裡修改，要加 mutating
struct CartList {
    var items: [CartItem] = []

    mutating func add(_ item: CartItem) {
        items.append(item)
    }
}
