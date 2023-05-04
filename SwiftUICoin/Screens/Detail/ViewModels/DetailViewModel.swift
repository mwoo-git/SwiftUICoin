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
    
    private var cancellables = Set<AnyCancellable>()
    
    enum InfoOption {
        case news, about
    }
    
    init(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            self.backup = backup
        } else {
            self.coin = coin
        }
        fetchCoinDetail()
        fetchBlockMedia()
        addSubscribers()
    }
    
    private func fetchCoinDetail() {
        Task {
            guard let coin = coin else { return }
            let detail = try await CoinGeckoService.fetchCoinDetails(withCoin: coin.name.lowercased())
            await MainActor.run {
                self.websiteURL = detail.links?.homepage?.first
            }
        }
    }
    
    private func fetchBlockMedia() {
        Task {
            guard let coin = coin else { return }
            let articles = try await BlockMediaService.fetchArticles(withCoin: coin)
            await MainActor.run {
                self.articles = articles
            }
        }
    }
    
    private func addSubscribers() {
        
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
