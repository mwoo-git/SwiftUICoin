//
//  StatusErrorView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/11.
//

import SwiftUI

struct StatusErrorView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack() {
            if viewModel.status == .status500 {
                Text("500")
                Text("서버에 문제가 발생하여 데이터를 받아오지 못했습니다.")
                Text("잠시 후에 다시 시도해주세요.")
                Text("뉴스 및 다른 기능은 사용 가능합니다.")
                Text("예상 소요 시간: 5분 ~ 1시간")
            } else if viewModel.status == .status429 {
                Text("429")
                Text("너무 많은 요청으로 인해 데이터를 받아오지 못했습니다.")
                Text("잠시 후에 다시 시도해주세요.")
                Text("뉴스 및 다른 기능은 사용 가능합니다.")
            }
        }
        .animation(.easeInOut, value: viewModel.status)
        .padding()
        .frame(width: UIScreen.main.bounds.width / 1.1)
        .background(Color.theme.searchBar)
        .cornerRadius(10)
        .font(.subheadline)
    }
}

struct StateErrorView_Previews: PreviewProvider {
    static var previews: some View {
        StatusErrorView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
