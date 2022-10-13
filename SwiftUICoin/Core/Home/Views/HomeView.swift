//
//  HomeView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showMenu: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            homeHeader
            HomeCoinListView()
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            Text("마켓")
                .font(.title2)
                .bold()
                .padding(.leading)
            Spacer()
            if !showMenu {
                HStack(spacing: 0) {
                    NavigationLink(
                        destination: SearchView()) {
                            IconView(iconName: "magnifyingglass")
                        }
                    IconView(iconName: showMenu ? "arrow.left" : "person.circle")
                        .onTapGesture {
                            withAnimation() {
                                showMenu.toggle()
                            }
                        }
                        .animation(.none, value: showMenu)
                }
            } else {
                IconView(iconName: "sun.min.fill")
                    .padding(.trailing, 18)
            }
        }
    }
}

