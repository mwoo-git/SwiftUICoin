//
//  GlobalViewModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/29.
//

import Foundation
import Combine

final class GlobalViewModel: ObservableObject {
    
    var globals: [GlobalModel]?
    
    @Published var indices: [GlobalModel] = []
    @Published var commodities: [GlobalModel] = []
    @Published var stocks: [GlobalModel] = []
    
    @Published var isRefreshing = false

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchInvesting()
    }
    
    func fetchInvesting() {
        Task {
            let globals = try await InvestingService.fetchGlobals()
            self.globals = globals
            Task { await fillterIndices() }
            Task { await fillterCommodities() }
            Task { await fillterStocks() }
        }
    }
    
    private func fillterIndices() async {
        guard let globals = globals else { return }
        let array = Array(globals.filter { $0.name != "S&P 500 VIX" }.prefix(6))
        await MainActor.run {
            self.indices = array
        }
    }

    private func fillterCommodities() async {
//         if 문으로 배열에 해당 범위가 있는지 체크하여 "Index out of range" 오류를 방지합니다.
        guard let globals = globals else { return }
        
        if 7 >= globals.startIndex && 13 < globals.endIndex {
            let array = globals[7...13].filter { $0.name != "Brent Oil" }
            await MainActor.run {
                self.commodities = array
            }
        }
    }

    private func fillterStocks() async {
        guard let globals = globals else { return }
        
        if 21 >= globals.startIndex && 26 < globals.endIndex {
            let array = Array(globals[21...26])
            await MainActor.run {
                self.stocks = array
            }
        }
    }
    
    func fetchGlobalList() {
        if !isRefreshing {
            fetchInvesting()
            isRefreshing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (indices.isEmpty ? 3 : 60)) {
                self.isRefreshing = false
            }
        }
    }
}
