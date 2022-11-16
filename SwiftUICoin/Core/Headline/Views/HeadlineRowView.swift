//
//  HeadlineRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import SwiftUI
import Kingfisher

struct HeadlineRowView: View {
    
    let headline: HeadlineModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                KFImage(URL(string: headline.authorImageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                    .cornerRadius(5)
                Text(headline.cleanAuthor)
                    .font(.footnote)
                    .padding(.leading, 5)   
            }
            .padding(.bottom, 10)
            Text(headline.title)
                .font(.title3)
                .lineLimit(2)
                .foregroundColor(Color.theme.textColor)
                .multilineTextAlignment(.leading)
            Spacer()
            HStack {
                Text(headline.cleanDate)
                    .font(.footnote)
                Spacer()
            }
            .overlay(
                MenuButtonView(url: headline.url, author: headline.cleanAuthor, title: headline.title)
                    .offset(x: 13)
                , alignment: .trailing
            )
        }
        .contentShape(Rectangle())
        .padding()
        .frame(height: 140)
        .foregroundColor(Color.theme.accent)
    }
}

struct HeadlineRowView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineRowView(headline: dev.headline)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

struct MenuButtonView: View {
    
    @State private var isShareSheetShowing = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL) var openURL
    
    let url: String
    let author: String
    let title: String
    
    var body: some View {
        Menu {
            Button(action: share) {
                HStack {
                    Text("공유")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            Button(action: {
                let email = SupportEmailModel(toAddress: "blockwide.ios@gmail.com", subject: "뉴스 문제 신고", body: """
                [\(author)] \(title)
                
                """)
                email.send(openURL: openURL)
            }) {
                HStack {
                    Text("문제 신고")
                    Image(systemName: "exclamationmark.bubble")
                }
            }
            
        } label:{
            Image(systemName: "ellipsis")
                .padding()
                .contentShape(Rectangle())
                .foregroundColor(Color.theme.accent)
        }
        .buttonStyle(ListSelectionStyle())
    }
    
    func share() {
        isShareSheetShowing.toggle()
        
        let url = URL(string: url)
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}
