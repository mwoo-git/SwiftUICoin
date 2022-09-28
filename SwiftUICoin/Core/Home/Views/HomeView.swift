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
    @State private var scrollViewOffset: CGFloat = 0
    @State private var startOffset: CGFloat = 0
    @State var isNavigationBarHidden = true
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            homeHeader
            homeBody
            
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
            IconView(iconName: showMenu ? "arrow.left" : "person.circle")
                .onTapGesture {
                    withAnimation() {
                        showMenu.toggle()
                    }
                }
                .animation(.none, value: showMenu)
            Spacer()
            if !showMenu {
                HStack {
                    NavigationLink(
                        destination: SearchView()) {
                            IconView(iconName: "magnifyingglass")
                        }
                }
            } else {
                IconView(iconName: "sun.min.fill")
                    .padding(.trailing, 18)
            }
        }
    }
    
    private var homeBody: some View {
        ScrollViewReader {proxyReader in
            ScrollView() {
                VStack {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section(header: VStack(spacing: 0) {
                            ListOptionView()
                            if viewModel.listOption == .coin {
                                SortOptionView()
                            }
                        }.background(Color.theme.background)
                        ) {
                            if viewModel.listOption == .watchlist {
                                WatchCoinListView()
                            } else {
                                AllCoinListView()
                            }
                        }
                    }
                }
                .id("SCROLL_TO_TOP")
                .overlay(scrollToTopGeometryReader)
            }
            .overlay(
                scrollToTopButton
                    .onTapGesture {
                        withAnimation {
                            proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                        }
                    }
                ,alignment: .bottomTrailing
            )
            .onChange(of: viewModel.listOption) { _ in
                proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
            }
        }
    }
    
    private var scrollToTopGeometryReader: some View {
        GeometryReader{proxy -> Color in
            DispatchQueue.main.async {
                if startOffset == 0 {
                    self.startOffset = proxy.frame(in: .global).minY
                }
                let offset = proxy.frame(in: .global).minY
                self.scrollViewOffset = offset - startOffset
            }
            return Color.clear
        }
    }
    
    private var scrollToTopButton: some View {
        Image(systemName: "arrow.up")
            .font(.title2)
            .foregroundColor(Color.white)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .foregroundColor(Color.theme.arrowButton)
            )
            .padding(.trailing, 30)
            .opacity(-scrollViewOffset > 145 ? 1: 0)
    }
}

