////
////  ExchangeOptionView.swift
////  SwiftUICoin
////
////  Created by Woo Min on 2022/10/16.
////
//
//import SwiftUI
//
//struct ExchangeOptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExchangeTabBarView(viewModel: DetailViewModel(coin: dev.coin, backup: nil))
//            .previewLayout(.sizeThatFits)
//    }
//}
//
//struct ExchangeTabBarView: View {
//    
//    @State var viewModel: DetailViewModel
//    @State private var selected: Int = 0
//    @State private var categories = ["BINANCE", "COINBASE", "FTX", "UPBIT"]
//    @Namespace var namespace
//    
//    var body: some View {
//        ScrollViewReader { proxy in
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack() {
//                    ForEach(Array(zip(categories.indices, categories)), id: \.0) { index, item in
//                        ExchangeTabBarItem(selected: $selected, viewModel: viewModel, namespace: namespace.self, id: index, tabBarItemName: item, tab: index)
//                            .onChange(of: selected) { _ in
//                                withAnimation(.easeInOut(duration: 0.2)) {
//                                    proxy.scrollTo(selected, anchor: .trailing)
//                                }
//                            }
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//struct ExchangeTabBarItem: View {
//    
//    @Binding var selected: Int
//    @State var viewModel: DetailViewModel
//    let namespace: Namespace.ID
//    let id: Int
//    var tabBarItemName: String
//    var tab: Int
//    
//    
//    
//    var body: some View {
//        VStack {
//            Text(tabBarItemName)
//                .foregroundColor(selected == tab ? Color.theme.textColor : Color.theme.accent)
//                .font(.subheadline)
//                .fontWeight(selected == tab ? .bold : .regular)
//        }
//        .id(id)
//        .animation(.easeInOut(duration: 0.2),  value: selected)
//        .padding(.trailing)
//        .onTapGesture {
//            selected = tab
//            viewModel.currentExchange = tabBarItemName
//        }
//    }
//}
