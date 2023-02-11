//
//  HeadlineView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import SwiftUI

struct HeadlineView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("categories") private var categories = ["비트코인", "이더리움", "증시", "연준", "금리", "환율", "NFT", "메타버스"]
    @State private var currentTab: Int = 0
    @State private var didChange = false
    
    var body: some View {
        VStack(spacing: 0) {
            header
            TabBarView(currentTab: $currentTab, categories: $categories)
            
            // categories가 수정되었을 때 탭뷰를 새롭게 로드하기 위해서 didChange를 사용합니다.
            switch didChange {
            case false:
                TabView(selection: self.$currentTab) {
                    ForEach(Array(zip(categories.indices, categories)), id: \.0) { index, item in
                        HeadlineListView(keyword: item)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                Spacer()
            default:
                TabView(selection: self.$currentTab) {
                    ForEach(Array(zip(categories.indices, categories)), id: \.0) { index, item in
                        HeadlineListView(keyword: item)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                Spacer()
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
        .environment(\.colorScheme, .dark)
//        .onChange(of: categories) { _ in
//            didChange.toggle()
//        }
//        .onAppear {
//            didChange.toggle()
//        }
        //        .onAppear {
        //            if viewModel.isDark {
        //                isDarkMode  = true
        //            } else {
        //                isDarkMode = false
        //            }
        //        }
    }
}

struct TabBarView: View {
    
    @Binding var currentTab: Int
    @Binding var categories: [String]
    @Namespace var namespace
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(Array(zip(categories.indices, categories)), id: \.0) { index, item in
                        TabBarItem(currentTab: $currentTab, namespace: namespace.self, id: index, tabBarItemName: item, tab: index)
                            .onChange(of: currentTab) { _ in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    proxy.scrollTo(currentTab, anchor: .center)
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct TabBarItem: View {
    
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    let id: Int
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        VStack() {
            Text(tabBarItemName)
                .foregroundColor(currentTab == tab ? Color.theme.textColor : Color.theme.accent)
                .font(.subheadline)
                .fontWeight(currentTab == tab ? .bold : .thin)
            if currentTab == tab {
                Color.theme.textColor
                    .frame(height: 2)
                    .matchedGeometryEffect(id: "underline", in: namespace)
                    .padding(.horizontal, 2)
            } else {
                Color.clear.frame(height: 2)
            }
        }
        .id(id)
        .animation(.easeInOut(duration: 0.2),  value: currentTab)
        .onTapGesture {
            currentTab = tab
        }
        .padding(.top)
        .contentShape(Rectangle())
    }
}

struct HeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HeadlineView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

private extension HeadlineView {
    var header: some View {
        HStack {
            Text("뉴스")
                .font(.title3)
                .bold()
                .padding(.leading)
            Spacer()
            HStack(spacing: 0) {
                NavigationLink(
                    destination: HeadlineSearchView()) {
                        IconView(iconName: "magnifyingglass")
                    }
                NavigationLink(
                    destination: HeadlineEditView(didChange: $didChange)) {
                        IconView(iconName: "list.bullet")
                    }
                SettingsButtonView()
            }
        }
    }
}
