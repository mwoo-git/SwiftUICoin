//
//  GlobalViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/29.
//

import Foundation
import Combine

final class GlobalViewModel: ObservableObject {
    
    @Published var indices: [GlobalModel] = []
    @Published var commodities: [GlobalModel] = []
    @Published var stocks: [GlobalModel] = []
    @Published var isRefreshing = false
    
    private let usaDataService = GlobalDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        usaDataService.$globals
            .sink { [weak self] (returnedItems) in
                self?.indices(globals: returnedItems)
                self?.commodities(globals: returnedItems)
                self?.stocks(globals: returnedItems)
            }
            .store(in: &cancellables)
    }
    
    private func indices(globals: [GlobalModel]) {
        self.indices = Array(globals.filter { $0.name != "S&P 500 VIX" }.prefix(6))
    }

    private func commodities(globals: [GlobalModel]) {
//         if 문으로 배열에 해당 범위가 있는지 체크하여 "Index out of range" 오류를 방지합니다.
        if 7 >= globals.startIndex && 13 < globals.endIndex {
            self.commodities = globals[7...13].filter { $0.name != "Brent Oil" }
        }
    }

    private func stocks(globals: [GlobalModel]) {
        if 21 >= globals.startIndex && 26 < globals.endIndex {
            self.stocks = Array(globals[21...26])
        }
    }
    
    func fetchGlobalList() {
        if !isRefreshing {
            usaDataService.getItem()
            isRefreshing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (indices.isEmpty ? 3 : 60)) {
                self.isRefreshing = false
            }
        }
    }
}
