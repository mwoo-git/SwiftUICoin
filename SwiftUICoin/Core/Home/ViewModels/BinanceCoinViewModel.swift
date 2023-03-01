//
//  BinanceCoinViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/02.
//

import Foundation
import Combine

class BinanceCoinViewModel: ObservableObject {
    @Published var coins = [BinanceCoin]()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        BinanceCoinDataService.shared.fetchCoins { [weak self] coins in
            DispatchQueue.main.async {
                self?.coins = coins ?? []
            }
        }
    }
    
    func binanceCoins(allCoins: [CoinModel], binanceCoins: [BinanceCoin]) -> [CoinModel] {
        var filteredCoins: [CoinModel] = []
        for coin in allCoins {
            if binanceCoins.contains(where: { $0.baseAsset.lowercased() == coin.symbol.lowercased() }) {
                filteredCoins.append(coin)
            }
        }
        return filteredCoins
    }
}
