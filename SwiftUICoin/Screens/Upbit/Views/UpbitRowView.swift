//
//  UpbitCoinRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI
import Combine

struct UpbitRowView: View {
    
    @StateObject var vm: UpbitCoinRowViewModel
    
    init(ticker: UpbitTicker, coin: UpbitCoin) {
        _vm = StateObject(wrappedValue: UpbitCoinRowViewModel(ticker: ticker, coin: coin))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                leftColumn
                Spacer()
                rightColmn
            }
            .padding(.bottom)
        }
        .padding(.horizontal)
        .padding(.top)
        .contentShape(Rectangle())
        .onAppear {
            vm.showTicker = true
//            vm.appendCode(market: vm.market)
        }
        .onDisappear {
            vm.showTicker = false
//            vm.deleteCode(market: vm.market)
        }
    }
}

private extension UpbitRowView {
    
    var leftColumn: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(vm.koreanName())
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.textColor)
                    .padding(.bottom, 3)
                Text(vm.symbol)
                    .foregroundColor(Color.theme.accent)
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                    .padding(.top, 10)
            }
        }
    }
    
    var rightColmn: some View {
        VStack(alignment:.trailing, spacing: 0) {
            Text(vm.changeRate)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.vertical, 5)
                .padding(.trailing, 3)
                .foregroundColor(vm.changeRate.contains("-") ? Color.theme.fallingColor : Color.theme.risingColor)
                .frame(width: UIScreen.main.bounds.width / 3.7, alignment: .trailing)
                .background(
                    vm.changeRate.contains("+") ? Color.theme.risingColor.opacity(vm.opacity) : Color.theme.fallingColor.opacity(vm.opacity)
                )
                .cornerRadius(5)
            Text(vm.price + "원")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
                .padding(.top, 3)
//            Text(vm.volume + "백만")
//                .font(.system(size: 14))
//                .fontWeight(.regular)
//                .foregroundColor(Color.gray.opacity(1))
//                .frame(width: UIScreen.main.bounds.width / 4.5, alignment: .trailing)
        }
        .padding(.top, -4)
    }
}

//struct UpbitRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpbitRowView(ticker: dev.upbitTicker)
//            .previewLayout(.sizeThatFits)
//    }
//}



