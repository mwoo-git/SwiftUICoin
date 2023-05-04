//
//  USADataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/29.
//

import Foundation

struct InvestingService {
    static func fetchGlobals() async throws -> [GlobalModel] {
        let urlString = "https://investing.com/"
        let url = URL(string: urlString)!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let globals = try await InvestingScraper.scrapeInvesting(from: data)
            
            return globals
        } catch {
            print("DEBUG: GlobalDataService.fetchGlobals() failed. \(error.localizedDescription)")
            throw error
        }
    }
}

