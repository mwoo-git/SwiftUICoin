//
//  UpbitCoinRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI

struct UpbitCoinRowView: View {
    
    @EnvironmentObject var UpbitVm: UpbitCoinViewModel
    @EnvironmentObject var HomeVm: HomeViewModel
    @StateObject private var vm = UpbitCoinRowViewModel()
    
    var ticker: UpbitTicker
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                leftColumn
                Spacer()
                rightColmn
            }
            .padding(.bottom, 10)
            
            Divider()
                .frame(height: 1)
                .opacity(0.4)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .contentShape(Rectangle())
        .onAppear {
            vm.showTicker = true
            vm.price = ticker.formattedTradePrice
            vm.changeRate = ticker.formattedChangeRate
            vm.volume = ticker.formattedAccTradePrice24H
            vm.market = ticker.market
        }
        .onDisappear {
            vm.showTicker = false
        }
        .onReceive(UpbitVm.$updatingTickers) { tickers in
            vm.updateView(tickers: tickers)
        }
    }
}

private extension UpbitCoinRowView {
    
    var leftColumn: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(UpbitVm.getKoreanName(for: ticker.market))
                    .font(.system(size: 15))
                    .fontWeight(.light)
                    .foregroundColor(Color.theme.textColor)
                    .padding(.bottom, 3)
                Text(ticker.market.replacingOccurrences(of: "KRW-", with: "").uppercased())
                    .foregroundColor(Color.theme.accent)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
            }
        }
    }
    
    var rightColmn: some View {
        HStack(alignment:.top, spacing: 0) {
            Text(vm.price)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(vm.color)
                .frame(width: UIScreen.main.bounds.width / 4.5, alignment: .trailing)
            Text(vm.changeRate)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .foregroundColor(vm.changeRate.contains("-") ? Color.theme.fallingColor : Color.theme.risingColor)
                .frame(width: UIScreen.main.bounds.width / 5, alignment: .trailing)
                
            Text(vm.volume + "백만")
                .font(.system(size: 14))
                .fontWeight(.regular)
                .foregroundColor(Color.gray.opacity(1))
                .frame(width: UIScreen.main.bounds.width / 4.5, alignment: .trailing)
        }
    }
}





