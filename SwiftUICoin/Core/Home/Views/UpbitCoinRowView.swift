//
//  UpbitCoinRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/03/03.
//

import SwiftUI
import Kingfisher

struct UpbitCoinRowView: View {
    
    @EnvironmentObject private var UpbitVm: UpbitCoinViewModel
    @EnvironmentObject private var HomeVm: HomeViewModel
    
    @State private var showTicker = false
    @State private var price = ""
    @State private var changeRate = ""
    @State private var volume = ""
    
    var ticker: UpbitTicker?
    
    var body: some View {
        
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            rightColmn
        }
        .padding()
        .contentShape(Rectangle())
        .onAppear {
            showTicker = true
            price = ticker?.formattedTradePrice ?? ""
            changeRate = ticker?.formattedChangeRate ?? ""
            volume = ticker?.formattedAccTradePrice24H ?? ""
        }
        .onDisappear {
            showTicker = false
        }
        .onReceive(UpbitVm.$updatingTickers) { tickers in
            guard showTicker else {
                return
            }
            
            if let updatedTicker = tickers.first(where: { $0.market == ticker?.market }), updatedTicker.formattedTradePrice != price {
                DispatchQueue.main.async {
                    price = updatedTicker.formattedTradePrice
                    changeRate = updatedTicker.formattedChangeRate
                    volume = updatedTicker.formattedAccTradePrice24H
                }
            }
        }
    }
}

struct UpbitCoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UpbitCoinRowView(ticker: dev.upbitTicker)
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            UpbitCoinRowView(ticker: dev.upbitTicker)
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension UpbitCoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            
//            KFImage(URL(string: HomeVm.getImageUrl(for: ticker?.market.replacingOccurrences(of: "KRW-", with: "").lowercased() ?? "") ?? ""))
//                .resizable()
//                .scaledToFit()
//                .frame(width: 32, height: 32)
//                .cornerRadius(5)
            
            VStack(alignment: .leading, spacing: 4) {
                if let koreanName = UpbitVm.getKoreanName(for: ticker?.market ?? "") {
                    Text(koreanName)
                    
                        .font(.headline)
                        .foregroundColor(Color.theme.textColor)
                }
                Text(ticker?.market.replacingOccurrences(of: "KRW-", with: "").uppercased() ?? "")
                    .foregroundColor(Color.theme.accent)
                    .font(.subheadline)
            }
            .padding(.leading, 14)
        }
    }
    
    private var rightColmn: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(ticker == nil ? "$0.00" : price )
                .bold()
                .font(.headline)
                .foregroundColor(ticker == nil ? Color.theme.accent : Color.theme.textColor)
            Text(ticker == nil ? "0.00%" : changeRate )
                .foregroundColor(ticker == nil ? Color.theme.accent : (ticker?.change == "FALL" ? Color.theme.red : Color.theme.green))
                .font(.subheadline)
        }
    }
}

