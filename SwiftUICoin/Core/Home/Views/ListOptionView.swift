//
//  ListOptionView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/26.
//

import SwiftUI

struct ListOptionView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            VStack() {
                Text("Watchlist")
                    .foregroundColor(viewModel.listOption == .watchlist ?  Color.white : Color.theme.accent)
                Capsule()
                    .fill(viewModel.listOption == .watchlist ?  Color.theme.binanceColor : Color.clear)
                    .frame(width: 30, height: 3)
            }
            .onTapGesture {
                viewModel.listOption = .watchlist
            }
            VStack() {
                Text("Coin")
                    .foregroundColor(viewModel.listOption == .coin ? Color.white : Color.theme.accent)
                Capsule()
                    .fill(viewModel.listOption == .coin ? Color.theme.binanceColor : Color.clear)
                    .frame(width: 30, height: 3)
            }
            .onTapGesture {
                viewModel.listOption = .coin
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
    }
}

//struct ListOptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListOptionView()
//    }
//}
