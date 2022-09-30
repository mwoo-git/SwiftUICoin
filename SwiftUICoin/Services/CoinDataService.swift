//
//  CoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/13.
//

import Foundation
import Combine
import SwiftUI

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoin()
    }
    
    private func getCoin() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        self.isLoading = true
        coinSubscription = NetWorkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetWorkingManager.handleCompletion, receiveValue: { [weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
                self?.isLoading = false
            })
    }
}
