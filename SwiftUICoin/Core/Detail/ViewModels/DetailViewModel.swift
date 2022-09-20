//
//  DetailViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/20.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDatailSecvice: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDatailSecvice = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDatailSecvice.$coinDateils
            .sink { (returnedCoinDetails) in
                print("코인 데이터 받았습니다.")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
        
    }
}
