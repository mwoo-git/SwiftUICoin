//
//  CoinDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/13.
//

import Foundation
import Combine
import SwiftUI

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    @Published var status: StatusCode = .status200
    
    var coinSubscription: AnyCancellable?
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL, status: Int)
        case internalError429(url: URL)
        case serverError500(url: URL, status: Int)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url, status: let status):
                return "[🔥] Bad response [\(status)] form URL: \(url)"
            case .internalError429(url: let url):
                return "[🔥] Bad response [429] 요청이 너무 많습니다. form URL: \(url)"
            case .serverError500(url: let url, status: let status):
                return "[🔥] Bad response [\(status)] 서버 오류 form URL: \(url)"
            case .unknown:
                return "[⚠️] Unknown error occured"
            }
        }
    }
    
    init() {
        getCoin()
    }
    
    func getCoin() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=24h") else { return }
        print("start download")
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          switch (output.response as? HTTPURLResponse)?.statusCode {
                          case 429:
                              self.status = .status429
                              throw NetworkingError.internalError429(url: url)
                          case 500, 501, 502, 503:
                              self.status = .status500
                              throw NetworkingError.serverError500(url: url, status: (output.response as? HTTPURLResponse)?.statusCode ?? 0)
                          default:
                              self.status = .unknown
                              throw NetworkingError.badURLResponse(url: url, status: (output.response as? HTTPURLResponse)?.statusCode ?? 0)
                          }
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink{ (completion) in
                switch completion {
                case .finished:
                    self.status = .status200
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnCoins) in
                self?.allCoins = returnCoins
                print("end download")
                self?.coinSubscription?.cancel()
            }
    }
}

