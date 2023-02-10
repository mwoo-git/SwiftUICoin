//
//  DetailViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/20.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var statistics = [StatisticModel]()
    @Published var articles = [ArticleModel]()
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var infoOption: InfoOption = .news
    @Published var coin: CoinModel?
    @Published var backup: BackupCoinEntity?
    
    private let coinDatailDataService: CoinDetailDataService
    private let articleDataService: BlockmediaDataService
    private var cancellables = Set<AnyCancellable>()
    
    enum InfoOption {
        case news, about
    }
    
    init(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            self.backup = backup
            self.coinDatailDataService = CoinDetailDataService(coin: nil, backup: backup)
            self.articleDataService = BlockmediaDataService(coin: nil, backup: backup)
        } else {
            self.coin = coin
            self.coinDatailDataService = CoinDetailDataService(coin: coin, backup: nil)
            self.articleDataService = BlockmediaDataService(coin: coin, backup: nil)
        }
        
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDatailDataService.$coinDateils
            .sink { [weak self] (returnedCoinDetails) in
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
            }
            .store(in: &cancellables)
        
        articleDataService.$articles
            .sink { [weak self] (returnedArticles) in
                self?.articles = returnedArticles
            }
            .store(in: &cancellables)
        
        if coin != nil {
            $coin
                .map(mapDataToStatistics)
                .sink { [weak self] (returnedArrays) in
                    self?.statistics = returnedArrays
                }
                .store(in: &cancellables)
        }

    }
    
    private func mapDataToStatistics(coinModel: CoinModel?) -> [StatisticModel] {
        let statistics = [
            ("Market Cap", coinModel?.marketCap?.asCurrency()),
            ("Circulation Supply", coinModel?.circulatingSupply?.asNumberWithoutDecimal()),
            ("Max Supply", coinModel?.maxSupply?.asNumberWithoutDecimal()),
            ("Total Supply", coinModel?.totalSupply?.asNumberWithoutDecimal())
        ]
        
        return statistics.compactMap { StatisticModel(title: $0.0, value: $0.1 ?? "") }
    }
}
