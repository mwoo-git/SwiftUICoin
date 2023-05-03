//
//  NoticeRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/11/05.
//

import SwiftUI

struct NoticeRowView: View {
    
    @Binding var currentTab: Int
    let id: Int
    var tab: Int
    @State private var showBody = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("[안내] 서비스 이용 안내")
                        .lineLimit(2)
                        .foregroundColor(Color.theme.textColor)
                    Text("2021.05.10")
                        .font(.caption)
                        .foregroundColor(Color.theme.accent)
                }
                Spacer()
                Image(systemName: showBody ? "chevron.down" : "chevron.up")
                    .foregroundColor(Color.theme.textColor)
            }
            .id(id)
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                if currentTab == tab {
                    showBody.toggle()
                } else {
                    currentTab = tab
                    showBody = true
                }
            }
            Divider()
                .padding(.horizontal)
            if currentTab == tab && showBody {
                VStack(spacing: 0) {
                    Text("안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요")
                        .padding(.horizontal)
                        
                }
                .padding(.vertical, 25)
                .background(Color.theme.arrowButton.frame(width: UIScreen.main.bounds.width * 2))
                
                
            }
        }
    }
}

struct NoticeRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeRowView(currentTab: .constant(0), id: 0, tab: 0)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
