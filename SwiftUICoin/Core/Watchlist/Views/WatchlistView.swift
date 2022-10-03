//
//  WatchlistView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/29.
//

import SwiftUI

struct WatchlistView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            header
            if viewModel.allCoins.isEmpty {
                LazyVStack {
                    ForEach(0..<5) { i in
                        CoinPlaceholderView()
                    }
                }
            } else {
                WatchCoinListView()
            }
            Spacer()
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WatchlistView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

extension WatchlistView {
    private var header: some View {
        HStack {
            Text("My Watchlist")
                .font(.title2)
                .bold()
                .padding(.leading)
            
            Spacer()
            
            HStack(spacing: 0) {
                
                if !viewModel.isEditing {
                    NavigationLink(
                        destination: SearchView()) {
                            IconView(iconName: "plus")
                        }
                    IconView(iconName: "pencil")
                        .onTapGesture {
                            withAnimation {
                                viewModel.isEditing.toggle()
                            }
                        }
                } else {
                    
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(Color.theme.openseaColor)
                        .padding()
                        .frame(height: 50)
                        .onTapGesture {
                            withAnimation {
                                viewModel.isEditing.toggle()
                            }
                        }
                }
            }
        }
    }
}
