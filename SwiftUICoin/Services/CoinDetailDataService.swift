//
//  CoinDetailDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/20.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDateils: CoinDetailModel? = nil
    
    var coinDetailSubscription: AnyCancellable?
    var coin: CoinModel?
    var backup: BackupCoinEntity?
    
    init(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            self.backup = backup
        } else {
            self.coin = coin
        }
        getCoinDetails()
    }
    
    private func getCoinDetails() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin == nil ? backup?.id ?? "" : coin?.id ?? "")?localization=true&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetWorkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetWorkingManager.handleCompletion, receiveValue: { [weak self] (returnCoinDetails) in
                self?.coinDateils = returnCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
