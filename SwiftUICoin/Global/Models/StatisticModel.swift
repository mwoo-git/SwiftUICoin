//
//  StatisticModel.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/21.
//  DetailView About coin

import Foundation

struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
