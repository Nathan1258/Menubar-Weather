//
//  PurchangeManager.swift
//  WeatherApp
//
//  Created by Nathan Ellis on 16/07/2024.
//

import SwiftUI
import RevenueCat


class PurchaseManager: ObservableObject{
    
    @Published var annualPrice: String = ""
    @Published var monthlyPrice: String = ""
    @Published var isSubscribed: Bool = false
    
    @Published var currentOffering: PurchaseType = .annual
    
    
    init() {
        fetchPrices()
        checkSubscriptionStatus()
    }
    
    func fetchPrices() {
        Purchases.shared.getOfferings { [weak self] (offerings, error) in
            guard let self = self else { return }
            if let offering = offerings?.current {
                if let annualProduct = offering.annual?.storeProduct {
                    currentOffering = .annual
                    self.annualPrice = annualProduct.localizedPriceString
                }
                if let monthlyProduct = offering.monthly?.storeProduct {
                    currentOffering = .monthly
                    self.monthlyPrice = monthlyProduct.localizedPriceString
                }
            } else if let error = error {
                print("Error fetching offerings: \(error.localizedDescription)")
            }
        }
    }
    
    func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { info, error in
            if let error = error {
                print("Error fetching purchaser info: \(error.localizedDescription)")
                return
            }
            
            guard let info = info else {
                print("No purchaser info available")
                return
            }
            self.isSubscribed = !info.activeSubscriptions.isEmpty
        }
    }
    
    func purchase(purchaseType: PurchaseType) {
        Purchases.shared.getOfferings {(offerings, error) in
            if let error = error {
                print("Error fetching offerings: \(error.localizedDescription)")
                return
            }
            
            guard let offering = offerings?.current else {
                print("No current offerings available")
                return
            }
            
            switch purchaseType {
            case .monthly:
                if let product = offering.monthly?.storeProduct {
                    self.purchaseProduct(product)
                } else {
                    print("Monthly product is not available")
                }
            case .annual:
                if let product = offering.annual?.storeProduct {
                    self.purchaseProduct(product)
                } else {
                    print("Annual product is not available")
                }
            }
        }
    }
    
    private func purchaseProduct(_ product: StoreProduct){
        Purchases.shared.purchase(product: product) {(transaction, customerInfo, error, userCancelled) in
            if error != nil { return }
            self.checkSubscriptionStatus()
        }
    }
    
    func restorePurchases() {
        Purchases.shared.restorePurchases { [weak self] (info, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error restoring transactions: \(error.localizedDescription)")
                return
            }
            self.checkSubscriptionStatus()
        }
    }
}

enum PurchaseType{
    case monthly
    case annual
}

