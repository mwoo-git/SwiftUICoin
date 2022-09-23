//
//  DetailViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/20.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    
    @Published var coin: CoinModel
    private let coinDatailSecvice: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDatailSecvice = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        $coin
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.statistics = returnedArrays
            }
            .store(in: &cancellables)
        
        coinDatailSecvice.$coinDateils
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.redableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinModel: CoinModel) -> [StatisticModel] {
        
        let marketCap = coinModel.marketCap?.asCurrency() ?? ""
        let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap)
        
        let circulationSupply = coinModel.circulatingSupply?.asNumberWithoutDecimal() ?? ""
        let circulationSupplyStat = StatisticModel(title: "Circulation Supply", value: circulationSupply)
        
        let maxSupply = coinModel.maxSupply?.asNumberWithoutDecimal() ?? ""
        let maxSupplyStat = StatisticModel(title: "Max Supply", value: maxSupply)
        
        let totalSupply = coinModel.totalSupply?.asNumberWithoutDecimal() ?? ""
        let totalSupplyStat = StatisticModel(title: "Total Supply", value: totalSupply)
        
        let statArray: [StatisticModel] = [
            marketCapStat, circulationSupplyStat, maxSupplyStat, totalSupplyStat
        ]
        
        return statArray
    }
}