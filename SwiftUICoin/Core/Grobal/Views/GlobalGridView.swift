//
//  GlobalGridView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/28.
//

import SwiftUI

struct GlobalGridView: View {
    
    @StateObject var viewModel: GlobalViewModel
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        Group {
            if viewModel.indices.isEmpty {
                placeholder
            } else {
                tabView
            }
        }
    }
}


struct GlobalGridView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalGridView(viewModel: GlobalViewModel())
    }
}

private extension GlobalGridView {
    var placeholder: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<6) {_ in
                GlobalPlaceholderView()
            }
        }
        .frame(height: 260)
    }
    
    var tabView: some View {
        TabView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.indices) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView(global: item)
                        })
                        .buttonStyle(ListSelectionStyle())
                }
            }
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.commodities) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView(global: item)
                        })
                        .buttonStyle(ListSelectionStyle())
                }
            }
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.stocks) { item in
                    NavigationLink(
                        destination: NavigationLazyView(GlobalDetailView(symbol: item.symbol, name: item.nameKR)),
                        label: {
                            GlobalItemView(global: item)
                        })
                        .buttonStyle(ListSelectionStyle())
                }
            }
        }
        .frame(height: 260)
        .tabViewStyle(.page(indexDisplayMode: .never))
        
    }
}
