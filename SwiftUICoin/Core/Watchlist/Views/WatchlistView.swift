//
//  WatchlistView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/29.
//

import SwiftUI

struct WatchlistView: View {
    
    @EnvironmentObject private var viewModel: WatchlistViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            header
            if viewModel.isLoading {
                Text("is Loading...")
            } else {
                Text("Loading end")
                WatchCoinListView()
            }
            Spacer()
            
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        WatchlistView()
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
