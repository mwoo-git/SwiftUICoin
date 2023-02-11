//
//  CoinDetailDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/20.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    private var coinDetailSubscription: AnyCancellable?
    private var coin: CoinModel?
    private var backup: BackupCoinEntity?
    
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
        
        coinDetailSubscription = NetworkingManager.download(url: url)
                .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }, receiveValue: { [weak self] (returnCoinDetails) in
                    self?.coinDetails = returnCoinDetails
                    self?.coinDetailSubscription?.cancel()
                })
    }
}
