//
//  CoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/13.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins = [CoinModel]()
    @Published var status: StatusCode = .status200
    
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoin()
    }
    
    func getCoin() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=24h") else { return }
        print("Start 코인리스트 Download")
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkingManager.NetworkingError.unknown
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    DispatchQueue.main.async { [weak self] in
                        self?.status = .status200
                    }
                    return output.data
                case 429:
                    DispatchQueue.main.async { [weak self] in
                        self?.status = .status429
                    }
                    throw NetworkingManager.NetworkingError.internalError429(url: url)
                case 500..<599:
                    DispatchQueue.main.async { [weak self] in
                        self?.status = .status500
                    }
                    throw NetworkingManager.NetworkingError.serverError500(url: url, status: httpResponse.statusCode)
                default:
                    DispatchQueue.main.async { [weak self] in
                        self?.status = .unknown
                    }
                    throw NetworkingManager.NetworkingError.badURLResponse(url: url, status: httpResponse.statusCode)
                }
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
                print("End Download")
            })
    }
}
