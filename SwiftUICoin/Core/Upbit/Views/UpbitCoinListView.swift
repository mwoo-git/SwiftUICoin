//
//  UpbitCoinListView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI

struct UpbitListView: View {
    
    @StateObject private var vm = UpbitCoinViewModel()
    
    var body: some View {
        List {
            ForEach(vm.displayedTickers) { ticker in
                UpbitRowView(ticker: ticker)
            }
            .onAppear {
                print("리스트 보여짐")
                vm.webSocketService.connect()
                
            }
            .onDisappear {
                vm.webSocketService.close()
            }
            .listRowBackground(Color.theme.background)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .onAppear {
            UITableView.appearance().separatorColor = UIColor(Color.theme.background)
        }
        .background(Color.theme.background)
        
    }
}

struct UpbitCoinListView_Previews: PreviewProvider {
    static var previews: some View {
        UpbitListView()
    }
}
