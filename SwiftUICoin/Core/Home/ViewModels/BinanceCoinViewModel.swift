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
    
    private lazy var dataService = BinanceCoinDataService()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        dataService.$coins
            .receive(on: RunLoop.main)
            .sink { [weak self] (coins) in
                self?.coins = coins
            }
            .store(in: &cancellables)
    }
    
    // 코인겍코에서 받은 코인 중에서 바이낸스에 상장된 코인만 보여줍니다.
    func binanceCoins(allCoins: [CoinModel], binanceCoins: [BinanceCoin]) -> [CoinModel] {
        guard !binanceCoins.isEmpty else {
            return allCoins
        }

        return allCoins.filter { coin in
            binanceCoins.contains { binanceCoin in
                binanceCoin.baseAsset.lowercased() == coin.symbol.lowercased()
            }
        }
    }
}



