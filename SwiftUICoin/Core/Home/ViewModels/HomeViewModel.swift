//
//  HomeViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var searchCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    @Published var totalBalance: String = "$12,345.67"
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // AllCoins Update
        dataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Search Filtering
        $searchText // Subcriber
            .combineLatest(dataService.$allCoins) // Subcriber
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
                // .debounce는 유저가 아무리 빠르게 타이핑해도 0.3초에 한번씩만 수행되도록 한다. 만약 설정하지 않는다면 유저가 빠르게 10자를 타이핑할 시 10번을 새롭게 수행하게 된다. 때문에 큰 데이터라면 좋지 않다.
            .map(filterCoins)
            .sink { [weak self] (returnCoins) in
                self?.searchCoins = returnCoins
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        
        // text가 비어있지 않을 때만 계속 진행, 비어있다면 coins를 리턴하라
        guard !text.isEmpty else {
            return coins
        }
        
        // 입력된 문자를 소문자로 변환
        let lowercasedText = text.lowercased()
        
        // StartingCoins를 순회하며 조건값으로 필터링하고 리턴하라
        return coins.filter { (coin) -> Bool in
            
            // 요소의 name, symbol, id에 lowercasedText를 포함한 것을 반환하라
            return coin.name.lowercased().contains(lowercasedText) || // || 는 or "혹은"이라는 뜻
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
}
