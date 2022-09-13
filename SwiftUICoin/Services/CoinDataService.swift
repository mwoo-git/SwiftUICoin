//
//  CoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/13.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoin()
    }
    
    private func getCoin() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default)) // 백그라운드 스레드에서 실행하라. 기본적으로 백그라운드 스레드에서 작업이 되지만 확실히 명시해준다.
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main) //메인 스레드에서 실행하라
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
            }
    }
}
