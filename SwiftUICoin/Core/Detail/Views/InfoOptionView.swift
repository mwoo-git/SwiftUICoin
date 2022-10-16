//
//  InfoOptionView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/13.
//

import SwiftUI

struct InfoOptionView: View {
    
    @StateObject var viewModel: DetailViewModel
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var body: some View {
        HStack {
            let lineWidth1: CGFloat = 58
            let lineWidth2: CGFloat = 60
            VStack {
                Text("주요 뉴스")
                    .foregroundColor(currentTab == 0 ? Color.theme.textColor : Color.theme.accent)
                    .font(.headline)
                    .fontWeight(currentTab == 0 ? .bold : .regular)
                if currentTab == 0 {
                    Color.theme.textColor
                        .frame(width: lineWidth1, height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                    
                } else {
                    Color.clear.frame(width: lineWidth1, height: 2)
                }
            }
            .animation(.easeInOut(duration: 0.2),  value: currentTab)
            .onTapGesture {
                currentTab = 0
            }
            VStack {
                Text("\((viewModel.coin?.symbol.uppercased() ?? viewModel.backup?.symbol?.uppercased()) ?? "") 정보")
                    .foregroundColor(currentTab == 1 ? Color.theme.textColor : Color.theme.accent)
                    .font(.headline)
                    .fontWeight(currentTab == 1 ? .bold : .regular)
                if currentTab == 1 {
                    Color.theme.textColor
                        .frame(width: lineWidth2, height: 2)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                } else {
                    Color.clear.frame(width: lineWidth2, height: 2)
                }
            }
            .animation(.easeInOut(duration: 0.2),  value: currentTab)
            .onTapGesture {
                currentTab = 1
            }
            .padding(.leading)
            Spacer()
        }
        .font(.headline)
        .padding(.horizontal)
        .padding(.top, 10)
        .foregroundColor(Color.theme.accent)
        .background(Color.theme.background)
    }
}


//struct InfoOptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoOptionView()
//    }
//}
