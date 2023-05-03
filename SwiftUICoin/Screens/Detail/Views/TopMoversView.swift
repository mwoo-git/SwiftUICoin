//
//  TopMoversView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/13.
//

import SwiftUI

struct TopMoversView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("사람들이 찾고 있는 인기 암호화폐 🔥")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    
                    ForEach(viewModel.trendCoins.prefix(10)) { coin in
                        NavigationLink(
                            destination: NavigationLazyView(DetailView(coin: coin, backup: nil)),
                            label: {
                                TopMoversItemView(coin: coin)
                            })
                            .buttonStyle(ListSelectionStyle())
                    }
                }
            }
        }
        .padding()
    }
}

struct TopMoversView_Previews: PreviewProvider {
    static var previews: some View {
        TopMoversView()
    }
}
