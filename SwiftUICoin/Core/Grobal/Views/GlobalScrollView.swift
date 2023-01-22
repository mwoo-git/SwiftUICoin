//
//  GlobalScrollView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/01/22.
//

import SwiftUI

struct GlobalScrollView: View {
    
    @StateObject var viewModel: GlobalViewModel
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.indices) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView2(global: item)
                        })
                }
                ForEach(viewModel.commodities) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView2(global: item)
                        })
                }
                ForEach(viewModel.stocks) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView2(global: item)
                        })
                }
            }
        }
        .padding(.leading)
    }
}

struct GlobalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalScrollView(viewModel: GlobalViewModel())
            .previewLayout(.sizeThatFits)
    }
}
